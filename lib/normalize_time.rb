module NormalizeTime

  def normalize_date(date)
    DateTime.parse(date) rescue nil
  end

  def normalize_start_and_end_time(start_time= nil, end_time=nil)
    start_time = normalize_date(start_time) || DateTime.new
    end_time   = normalize_date(end_time) || Time.zone.now
    start_time,end_time = end_time,start_time if(start_time > end_time)
    [start_time, end_time]
  end

end
