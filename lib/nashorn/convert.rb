class << Nashorn

  def to_rb(object)
    return nil if Nashorn::JS::ScriptObjectMirror.isUndefined(object)
    # ConsString for optimized String + operations :
    return object.toString if object.is_a?(Java::JavaLang::CharSequence)
    object
  end
  alias_method :to_ruby, :to_rb

  def to_js(object)
    case object
    when NilClass              then object
    when String, Numeric       then object.to_java
    when TrueClass, FalseClass then object.to_java
    when Nashorn::JS::JSObject then object
    #when Array                 then array_to_js(object)
    #when Hash                  then hash_to_js(object)
    when Time                  then time_to_js(object)
    when Method, UnboundMethod then Nashorn::Ruby::Function.wrap(object)
    when Proc                  then Nashorn::Ruby::Function.wrap(object)
    when Class                 then Nashorn::Ruby::Constructor.wrap(object)
    else Nashorn::Ruby::Object.wrap(object)
    end
  end
  alias_method :to_javascript, :to_js

  def args_to_rb(args)
    args.map { |arg| to_rb(arg) }
  end

  def args_to_js(args)
    args.map { |arg| to_js(arg) }.to_java
  end

  private

  #def array_to_js(rb_array)
  #end

  #def hash_to_js(rb_hash)
  #end

  def time_to_js(time)
    time.to_java
  end

end