module StreamWithDuration
  def duration_ms
    @stream_info["Duration"].to_i if @stream_info["Duration"]
  end

  def duration_s
    @stream_info["Duration"].to_f / 1000.0 if @stream_info["Duration"]
  end

  def duration_time_and_frames
    @stream_info["Duration/String4"]
  end
end