Analytics = Segment::Analytics.new({
    write_key: 'RaiFx9Ctra',
    on_error: Proc.new { |status, msg| print msg }
})
