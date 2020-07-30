class RickCable < BaseCable
  def rick
    Rails.logger.debug("hi we're in RickCable")

    stream partial: "rick/rick", locals: { foo: 'foo', bar: 'bar' }
  end
end
