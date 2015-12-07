module MediaInfoLib
  class AudioStream < MediaInfoLib::Stream
    
    def format
      @stream_info["Format"]
    end

    def format_long
      [@stream_info["Format"], @stream_info["Format_Version"], @stream_info["Format_Profile"]].compact.join ' '
    end

    def language
      @stream_info["Language"]
    end

    def language_full_name
      @stream_info["Language/String1"]
    end
    
    def samplerate
      @stream_info["SamplingRate"].to_i if @stream_info["SamplingRate"]
    end
    
    def channels
      (@stream_info["Channel(s)_Original"] || @stream_info["Channel(s)"]).to_i
    end
    
    def mono?
      1 == channels
    end
    
    def stereo?
      1 < channels
    end
    
    def duration
      @stream_info["Duration"].to_i if @stream_info["Duration"]
    end
    
    def bitrate
      @stream_info["BitRate"].to_i if @stream_info["BitRate"]
    end

    def bitrate_formatted
      @stream_info["BitRate/String"]
    end

    def bitrate_mode
      @stream_info["BitRate_Mode"]
    end

    def bit_depth
      @stream_info["BitDepth"].to_i if @stream_info["BitDepth"]
    end
    
    def vbr?
      @stream_info["BitRate_Mode"] == "VBR"
    end
    
    def cbr?
      @stream_info["BitRate_Mode"] == "CBR"
    end

    def encoded_date
      Time.parse("#{@stream_info["Encoded_Date"]} UTC") if @stream_info["EncodedDate"]
    end
    
  end
end