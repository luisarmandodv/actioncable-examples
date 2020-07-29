class SyncsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams # Unsubscribes all streams associated with this channel from the pubsub queue. I'm not sure if this belongs in follow.
    stream_name = "integration_name:#{data['user_id'].to_i}:sync"
    puts "follow() stream #{stream_name}"
    stream_from stream_name
  end

  def unfollow
    stop_all_streams
  end
end
