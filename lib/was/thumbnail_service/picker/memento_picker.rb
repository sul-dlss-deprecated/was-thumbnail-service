module Was
  module ThumbnailService
    class MementoPicker
 
      def initialize(uri_id)
        @uri_id = uri_id
      end
      
      def pick_mementos
        mementos_list = upload_mementos_list
        chosen_memento_list = choose_mementos(mementos_list)
        update_chosen_list_database chosen_memento_list
        #return chosen_memento_list
      end
      
      def upload_mementos_list
        mementos_list = []
        mementos_query_result = Memento.where("uri_id = ?", @uri_id)
        mementos_query_result.each do |memento|
          mementos_list.push({:id=>memento[:id], :simhash_value=>memento[:simhash_value]})
        end 
      end
      
      def choose_mementos mementos_list
        # Here, we can change the algorithm class
        return MementoPickerThresholdGrouping.choose_mementos(mementos_list)
      end
      
      def update_chosen_list_database chosen_memento_list
        chosen_memento_list.each do |memento_id|
          memento = Memento.find memento_id
          memento.update(is_selected: 1)
        end
      end
    end
  end
end