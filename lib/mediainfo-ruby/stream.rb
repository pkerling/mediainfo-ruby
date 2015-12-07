module MediaInfoLib
  class Stream
    #class InvalidStreamType < Mediainfo::Error; end
        
    def initialize(stream_info)
      @stream_info = stream_info
    end

    def id
      @stream_info["ID"].to_i if @stream_info["ID"]
    end

  end
end