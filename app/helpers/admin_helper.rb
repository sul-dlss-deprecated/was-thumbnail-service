module AdminHelper

  def get_memento_uri_from_handler(handler)
    memento_uri = nil
    begin
      id = extract_memento_id(handler)
      memento_uri = extract_memento_uri(id) if id.present?
    rescue => e
      Honeybadger.notify e
      return e.message
    end
    return memento_uri.nil? ? "Can't extract uri from #{handler}" : memento_uri
  end

  def extract_memento_id(handler)
    memento_id_index = handler.index('memento_id:')
    raise "Problem in extracting memento_id from handler: #{handler}" if memento_id_index.nil?
    start_memento_id = memento_id_index + 12

    end_memento_id_idx =  handler.index('druid_id:')
    raise "Problem in extracting memento_id from handler: #{handler}" if end_memento_id_idx.nil?

    return handler[start_memento_id, end_memento_id_idx - start_memento_id - 1]
  end

  def extract_memento_uri(id)
    memento = Memento.find id
    return memento.memento_uri
  end

  def get_druid_from_handler(handler)
    druid_id_idx = handler.index('druid_id: ')
    raise "Couldn't extract druid_id from handler: #{handler}" if druid_id_idx.nil?
    start_druid = druid_id_idx + 10
    return handler[start_druid, 11]
  end

end
