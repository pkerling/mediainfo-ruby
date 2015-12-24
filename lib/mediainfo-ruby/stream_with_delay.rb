module MediaInfoLib
  module StreamWithDelay
    def delay_ms
      @stream_info["Delay"].to_f if @stream_info["Delay"]
    end

    def delay_s
      @stream_info["Delay"].to_f / 1000.0 if @stream_info["Delay"]
    end
  end
end
