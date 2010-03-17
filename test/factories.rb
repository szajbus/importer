class Factory::Proxy::Insert < Factory::Proxy::Build
  def result
    if @instance.connection.prefetch_primary_key?(@instance.class.table_name)
      @instance.id = @instance.connection.next_sequence_value(@instance.class.sequence_name)
    end

    quoted_attributes = @instance.send(:attributes_with_quotes)

    statement = if quoted_attributes.empty?
      @instance.connection.empty_insert_statement(@instance.class.table_name)
    else
      "INSERT INTO #{@instance.class.quoted_table_name} " +
      "(#{quoted_column_names.join(', ')}) " +
      "VALUES(#{quoted_attributes.values.join(', ')})"
    end

    @instance.id = @instance.connection.insert(statement, "#{@instance.class.name} Create",
      @instance.class.primary_key, @instance.id, @instance.class.sequence_name)

    @instance.instance_eval do
      @new_record = false
    end

    @instance
  end
end

class Factory
  def self.insert (name, overrides = {})
    factory_by_name(name).run(Proxy::Insert, overrides)
  end
end

Factory.define :product, :default_strategy => :insert do |f|
  f.customid      "1"
  f.name          "A product"
  f.description   "A desc"
  f.price         100
end