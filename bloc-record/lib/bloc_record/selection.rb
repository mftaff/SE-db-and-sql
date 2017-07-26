require 'sqlite3'

module Selection
    def find(*ids)
        return "ERROR! Incorrect Input" unless validate_positive_integer(ids)
        
        if ids.length == 1
            find_one(ids.first)
        else
            rows = connection.execute <<-SQL
                SELECT #{columns.join ","} FROM #{table}
                WHERE id IN (#{ids.join(",")});
            SQL
            
            rows_to_array(rows)
        end
    end
    
    def find_one(id)
        return "ERROR! Incorrect Input" unless validate_positive_integer([id])
        
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            WHERE id = #{id};
        SQL

        init_object_from_row(row)
    end
    
    def find_by(attribute, value)
        return "ERROR! Incorrect Input" unless validate_string(attribute)
        
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            WHERE #{attribute} = #{BlocRecord::Utility.sql_strings(value)};
        SQL
        
        init_object_from_row(row)
    end
    
    def find_each(attribute, *values)
        return "ERROR! Incorrect Input" unless validate_string(attribute)
        values_string = values.map { |val| BlocRecord::Utility.sql_strings(value) }.join ","
        
        rows = connection.execute <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            WHERE #{attribute} IN (#{values_string});
        SQL
        
        block_given? ? rows.each { |row| yield } : rows_to_array(rows)
    end
    
    def take(num=1)
        return "ERROR! Incorrect Input" unless validate_positive_integer(num)
        
        if num > 1
            rows = connection.execute <<-SQL
                SELECT #{columns.join ","} FROM #{table}
                WHERE id IN (SELECT id FROM table ORDER BY RANDOM() LIMIT #{num});
            SQL
            
            rows_to_array(rows)
        else
            take_one
        end
    end
    
    def take_one
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            WHERE id IN (SELECT id FROM table ORDER BY RANDOM() LIMIT 1);
        SQL
        
        init_object_from_row(row)
    end
    
    def first
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            ORDER BY id
            ASC LIMIT 1;
        SQL
        
        init_object_from_row(row)
    end
    
    def last
        row = connection.get_first_row <<-SQL
            SELECT #{columns.join ","} FROM #{table}
            ORDER BY id
            DESC LIMIT 1;
        SQL
        
        init_object_from_row(row)
    end
    
    def all
        rows = connection.execute <<-SQL
            SELECT #{columns.join ","} FROM #{table};
        SQL
        
        rows_to_array(rows)
    end
    
    private
    
    def init_object_from_row(row)
        if row
            data = Hash[columns.zip(row)]
            new(data)
        end
    end
    
    def rows_to_array(rows)
        rows.map { |row| new(Hash[columns.zip(row)]) }
    end
    
    # Added for assignment 03
    def validate_positive_integer(datum)
        datum.each { |d| return false if (!d.is_a? Integer) || d <= 0 }
        true
    end
    
    # Added for assignment 03
    def validate_string(data)
        return false if not data.is_a? String
        true
    end
end
