module MediaInfoLib
  class VideoStream < MediaInfoLib::Stream
    
    def width
      @stream_info["Width"].to_i if @stream_info["Width"]
    end

    def height
      @stream_info["Height"].to_i if @stream_info["Height"]
    end
    
    def display_aspect_ratio
      @stream_info["DisplayAspectRatio/String"]
    end
    
    alias :aspect_ratio :display_aspect_ratio

    def pixel_aspect_ratio
      @stream_info["PixelAspectRatio"].to_f if @stream_info["PixelAspectRatio"]
    end
    
    def rotation
      @stream_info["Rotation"].to_f if @stream_info["Rotation"]
    end
    
    def codec
      @stream_info["CodecID"]
    end
      
    def codec_url
      @stream_info["CodecID/URL"]
    end
    
    def codec_name
      @stream_info["CodecID/Info"]
    end

    def format
      @stream_info["Format"]
    end

    def format_long
      [@stream_info["Format"], @stream_info["Format_Version"], @stream_info["Format_Profile"]].compact.join ' '
    end

    def color_space
      @stream_info["ColorSpace"]
    end

    def chroma_subsampling
      @stream_info["ChromaSubsampling"]
    end

    def framerate
      @stream_info["FrameRate"].to_f if @stream_info["FrameRate"]
    end
    
    alias :fps :framerate

    def frame_count
      @stream_info["FrameCount"].to_i if @stream_info["FrameCount"]
    end
    
    def vfr?
      @stream_info["FrameRate_Mode"] == "VFR"
    end
    
    def cfr?
      @stream_info["FrameRate_Mode"] == "CFR"
    end
    
    def bitrate
      @stream_info["BitRate"].to_i if @stream_info["BitRate"]
    end
    
    def bitdepth
      @stream_info["BitDepth"].to_i if @stream_info["BitDepth"]
    end

    def bitrate_formatted
      @stream_info["BitRate/String"]
    end

    def bitrate_mode
      @stream_info["BitRate_Mode"]
    end
    
    def vbr?
      @stream_info["BitRate_Mode"] == "VBR"
    end
    
    def cbr?
      @stream_info["BitRate_Mode"] == "CBR"
    end

    def scan_type
      @stream_info["ScanType"]
    end

    def interlaced?
      scan_type == "Interlaced"
    end

    def progressive?
      scan_type == "Progressive"
    end


    def gop_settings
      @stream_info["Format_Settings_GOP"]
    end

    def gop_mode
      @stream_info["Gop_OpenClosed"]
    end

    def encoded_date
      Time.parse("#{@stream_info["Encoded_Date"]} UTC") if @stream_info["EncodedDate"]
    end

    include StreamWithDuration
    
  end
end