class Node
  attr_accessor :data, :right, :left
  def initialize(data)
    @data = data
    @right = nil
    @left = nil
  end
end

class Tree
  attr_accessor :root

  def initialize(array)
    @root = build_tree(array)
  end

  def build_tree(arr)
    array = arr.sort.uniq
    return nil if array.empty?

    middle = array.length / 2
    root = Node.new(array[middle])
    root.left = build_tree(array[0...middle])
    root.right = build_tree(array[middle + 1..-1])
    root
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    return Node.new(value) if node.nil?

    if value == node.data
        return node
    elsif value < node.data
        node.left = insert(value, node.left)
    else
        node.right = insert(value, node.right)
    end
    node
  end

  def delete(value, node = @root)
    return node if node.nil?

    if value < node.data
      node.left = delete(value, node.left)
      node
    elsif value > node.data
      node.right = delete(value, node.right)
      node
    elsif node.left.nil?
      temp = node.right
      temp
    elsif node.right.nil?
      temp = node.left
      temp
    else
      #find successor
      parent = node
      successor = node.right
      while successor.left != nil
        parent = successor
        successor = successor.left
      end
        # Delete successor.  Since successor
        # is always left child of its parent
        # we can safely make successor's right
        # right child as left of its parent.
        # If there is no succ, then assign
        # succ.right to succParent.right
      if parent != node
        parent.left = successor.right
      else
        parent.right = successor.left
      end
      node.data = successor.data
      node
    end
  end

  def find(value, node = @root)
    return nil if node.nil?

    if value != node.data
      "There is no #{value}"
    elsif value == node.data
      node.data
    elsif value < node.data
      find(value, node.left)
    elsif value > node.data
      find(value, node.right)
    end
  end

end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.insert(40)
tree.insert(4)
tree.insert(8)
tree.insert(2)
tree.delete(1)
tree.delete(67)
tree.pretty_print

tree.find(55)