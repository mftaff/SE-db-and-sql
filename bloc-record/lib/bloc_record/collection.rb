module BlocRecord
    class Collection < Array
        def update_all(updates)
            ids = seld.map(&:id)
            self.any? ? self.first.class.update(ids, updates) : false
        end
    end
end
