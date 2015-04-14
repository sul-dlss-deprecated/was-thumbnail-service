module AdminHelper
  
  def get_memento_uri_from_handler(handler)
    id = extract_memento_id(handler)
    if id.nil? then
      return "Can't extract uri from #{handler}"
    end
    return extract_memento_uri(id)
  end
  
  def extract_memento_id(handler)
    start_memento_id = handler.index("memento_id:")+12
    end_memento_id =  handler.index("druid_id:")
    
    start_druid = end_memento_id+10
    end_druid = -1
    
    return handler[start_memento_id,end_memento_id-start_memento_id-1] 
  end
  
  def extract_memento_uri(id)
    begin
      memento = Memento.find id
      return memento.memento_uri
    rescue =>e
      return e.message
    end
  end
  
  def get_druid_from_handler(handler)
    start_druid =  handler.index("druid_id:")+9
    return handler[start_druid, 10]
  end
  
end
