# frozen_string_literal: true

# Exposes file interaction methods
class FileController
  def initialize(file_path)
    @file_path = file_path
    @text = File.read(@file_path).split("\n")
  end

  def index
    @text
  end

  def find(id)
    @text[id - 1]
  end

  def where(pattern)
    @text.filter { |str| str.match?(Regexp.new(pattern)) }
  end

  def update(id, data)
    @text[id - 1] = data
    File.write(@file_path, @text.join("\n"))
    @text
  end

  def delete(id)
    @text.delete_at(id - 1)
    File.write(@file_path, @text.join("\n"))
    @text
  end
end
