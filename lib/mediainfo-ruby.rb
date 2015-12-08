require 'pp'
require 'time'
# Load the C++ library.
$:.unshift "#{File.dirname(__FILE__)}/../ext/mediainfo_ruby/"
require "mediainfo_ruby"

module MediaInfoLib
   module AttrReaders
    def m_attr_reader(attribute, infokey)
      define_method attribute do
        @stream_info[infokey]
      end
    end
    
    def date_reader(attribute, infokey)
      
    end
  end
end


require "mediainfo-ruby/stream_with_duration"
require "mediainfo-ruby/stream"
require "mediainfo-ruby/general_stream"
require "mediainfo-ruby/audio_stream"
require "mediainfo-ruby/video_stream"
require "mediainfo-ruby/image_stream"
require "mediainfo-ruby/menu_stream"
require "mediainfo-ruby/text_stream"

module MediaInfoRubyisms_Streams
	ThingsWithMultipleStreams = [:video, :audio]

	# Set to true if you want empty values
	attr_reader :empty_values

	attr_reader :include_deprecated

	attr_reader :include_inform

	# A symbol map to translate from the Rubyisms we use on mediainfo-ruby
	# to the constants libmediainfo uses.
	StreamKindSymbolsMap = {
			:general=>MediaInfoLib_StreamKind::General,
			:video=>MediaInfoLib_StreamKind::Video,
			:audio=>MediaInfoLib_StreamKind::Audio,
			:text=>MediaInfoLib_StreamKind::Text,
			:chapters=>MediaInfoLib_StreamKind::Chapters,
			:image=>MediaInfoLib_StreamKind::Image,
			:menu=>MediaInfoLib_StreamKind::Menu,
			:max=>MediaInfoLib_StreamKind::Max
	}

	# Call inform and remove the DOS-linefeeds. Useful for quick printout
	# of a bunch of media information
	def inform
		self._inform.split("\r")
	end

  # Returns how many streams in total this file has.
	def streams; self.count_get(MediaInfoLib_StreamKind::General, -1) ; end

  # Returns how many streams are audio streams
	def audio_streams ; self.count_get(MediaInfoLib_StreamKind::Audio, -1) ; end

	# Returns how many streams are video streams
	def video_streams ; self.count_get(MediaInfoLib_StreamKind::Video, -1); end

	# Returns how many streams are chapter streams
	def chapter_streams ; self.count_get(MediaInfoLib_StreamKind::Chapters, -1); end

  # Returns how many streams are image streams
	def image_streams ; self.count_get(MediaInfoLib_StreamKind::Image, -1); end

	# Returns how many streams are menu streams
	def menu_streams ; self.count_get(MediaInfoLib_StreamKind::Menu, -1); end

	# Returns a map of all the possible option definitions,
	# where the key is the option we can ask for and the 
	# value is the help for that option.
	# By default, anything marked as deprecated in the underlying 
	# library is removed.
	def option_definitions
		option_map = {:general=>{}}
		current = :general
		switching = true
		current_map = option_map[:general]

		option_defs = parameters_csv.each_line{|row| 
			if row.strip == ""
				switching = true
			else
				kv = row.split(";")
				if kv.length == 1 && switching
					topic = kv[0].chomp.downcase.to_sym
					current_map = option_map[topic]
					if current_map.nil?
						option_map[topic] = current_map = {}
					end
					switching = false
				else
					key   = kv[0]
					value = kv[1].nil? ? nil : kv[1].chomp
					current_map[key] = value unless ! (self.include_deprecated ) && kv[1].nil? ? false : kv[1].include?("Deprecated")
				end
			end
		}
		option_map
	end
	
	def parameters_csv
		params_csv = self.option("Info_Parameters_CSV", "")
		if RUBY_PLATFORM =~ /darwin/
			params_csv = params_csv.gsub("\r", "\n")
		end
		params_csv
	end

	# It introspects a video. This means returning a map of all the 
	# values for a definition. By default empty values are not returned.
	# Send with true to return empty values
	def introspect
		results = {}
		self.option_definitions.each{|topic, topic_parameters|
			kind_constant = StreamKindSymbolsMap[topic]
			if ! kind_constant.nil?
				if ThingsWithMultipleStreams.include?(topic)
					streams = self.send("#{topic.to_s}_streams".to_sym)
					results[topic] = (0..(streams-1)).collect{|ix| introspect_topic(kind_constant, topic_parameters, ix) }
				else
					results[topic] = introspect_topic(kind_constant, topic_parameters)
				end
			end
		}
		results
	end

private
  def introspect_topic(kind_constant, topic_parameters, stream_index=0)
		result = {}
		topic_parameters.each{|key, value|
			value = self.get_value(kind_constant, stream_index, key, MediaInfoLib_InfoKind::Text, MediaInfoLib_InfoKind::Name)
	
			if self.empty_values == true || value.length > 0
				result[key] = value
			end
			if key == "Inform"
				result.delete(key) if ! self.include_inform
			end
			# self.get(kind_constant, 1,0, key) # Something like this
		}
		result
	end
  
end


module MediaInfoLib

  class MediaInfo
  
    SECTIONS             = [:general, :video, :audio, :image, :menu, :text]
    STREAM_SECTIONS      = SECTIONS - [:general]
    
    STREAM_TYPES_MAP = {
      :general => MediaInfoLib::GeneralStream,
      :video => MediaInfoLib::VideoStream,
      :audio => MediaInfoLib::AudioStream,
      :image => MediaInfoLib::ImageStream,
      :menu => MediaInfoLib::MenuStream,
      :text => MediaInfoLib::TextStream
    }
  
    #def initialize(path = nil)
    #  self.open(path) unless path.nil?
    #end

    def open(path)
      empty_values = true
      
      res = _open(path)
      raise Errno::ENOENT if 0 == res
    
      (yield self; close) if block_given?
    
      self
    end
 
    def streams
      streams = {
      }
      introspect.each do |k, v| 
        next if STREAM_TYPES_MAP[k].nil? || v.nil? || v.empty?
        
        if v.respond_to? :to_ary
          streams[k] = v.map {|s| STREAM_TYPES_MAP[k].new(s)}
        else
          streams[k] = STREAM_TYPES_MAP[k].new(v)
        end
        
      end
      streams
    end

    def general
      streams[:general]
    end

    def video?
      (!streams[:video].nil? && streams[:video].count > 0)
    end
    
    def video
      streams[:video].first unless streams[:video].nil?
    end

    def audio?
      (!streams[:audio].nil? && streams[:audio].count > 0)
    end
  
    def audio
      streams[:audio].first unless streams[:audio].nil?
    end
    
    def image?
      !streams[:image].nil?
    end
  
    def text?
      !streams[:text].nil?
    end
    
    def menu?
      !streams[:menu].nil?
    end
    
    def close
      _close()
    end
  
    def option(param1, param2) # TODO: WHAT ARE THOSE?
      _option(param1, param2)
    end
  
    def version()
      option("Info_Version", "").sub /MediaInfoLib - v/, ""
    end
  
  	include(MediaInfoRubyisms_Streams)
  end
end
