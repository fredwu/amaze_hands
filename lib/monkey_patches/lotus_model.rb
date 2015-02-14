# @see https://github.com/lotus/model/issues/153
Lotus::Model::Adapters::Memory::Query.class_eval do
  protected

  def method_missing(m, *args, &blk)
    if @collection.repository.respond_to?(m)
      @collection.repository.public_send(m, *args, &blk)
    else
      super
    end
  end
end
