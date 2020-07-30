class RickCable < BaseCable
  def rick
    a = 1
    b = 2

    stream partial: "rick/rick", locals: { a: a, b: b }
  end
end
