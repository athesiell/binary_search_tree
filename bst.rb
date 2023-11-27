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
        # If there is no successor, then assign
        # successor.right to parent.right
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

  def level_order(node = @root)
    return [] if node.nil?

    queue = []
    output = []
    queue.push(node)
    while !queue.empty?
      current = queue.shift
      queue.push(current.left) if current.left != nil
      queue.push(current.right) if current.right != nil
      block_given? ? yield(current.data) : output.push(current.data)
    end
    puts "Level order: #{output}"
  end

  def inorder(node = @root, &block)
    return [] if node.nil?
    
    output = []
    left = inorder(node.left, &block)
    output += left unless left.empty?

    block_given? ? yield(node.data) : output.push(node.data)

    right = inorder(node.right, &block)
    output += right unless right.empty?

    output unless block_given?

    # another easier method to do it is:
    # inorder(node.left)
    # print "#{node.data} "
    # inorder(node.right)
  end

  def preorder(node = @root, &block)
    return [] if node.nil?

    output = []
    block_given? ? yield(node.data) : output.push(node.data)

    left = preorder(node.left, &block)
    output += left unless left.empty?

    right = preorder(node.right, &block)
    output += right unless right.empty?

    output unless block_given?

    # print "#{node.data}"
    # preorder(node.left)
    # preorder(node.right)
  end

  def postorder(node = @root, &block)
    return [] if node.nil?

    output = []
    left = postorder(node.left, &block)
    output += left

    right = postorder(node.right, &block)
    output += right

    block_given? ? yield(node.data) : output.push(node.data)

    output unless block_given?

    # postorder(node.left)
    # postorder(node.right)
    # print "#{node.data}"
  end

  def height(node = @root)
    return -1 if node.nil?

    left = height(node.left)
    right = height(node.right)
    heigth = [left, right].max + 1
  end

  def depth(node = @root, value)
    return -1 if node.nil?

    dist = -1
    if value == node.data
      return 0
    else
      left = depth(node.left, value)
      right = depth(node.right, value)

      if left >= 0
        left + 1
      elsif right >= 0
        right + 1
      else
        return -1
      end
    end
  end

  def balanced?(node = @root)
    return true if node.nil?

    left = height(node.left)
    right = height(node.right)
    if (left - right).abs <= 1 && balanced?(node.left)==true && balanced?(node.right)==true
      return true
    else
      return false
    end
  end

  def rebalance
    array = inorder
    @root = build_tree(array)
  end

  def insert_nodes
    rand(2..10).times do
    insert(rand(100..999))
    end
  end
end

def driver
  tree = Tree.new(Array.new(15) { rand(1..100) })
  puts "Creating new tree"
  puts ""
  puts "Checking if tree is balanced"
  puts ""
  puts "Tree Balanced: #{tree.balanced?}"
  puts ""
  puts "Original Tree:"
  tree.pretty_print
  puts ""
  tree.level_order
  puts ""
  puts "In order #{tree.inorder} "
  puts ""
  puts "Preorder #{tree.preorder}"
  puts ""
  puts "Postorder #{tree.postorder}"
  puts ""
  puts "Inserting additional numbers in the tree!"
  tree.insert_nodes
  puts ""
  puts "Checking if tree balanced after inserting additional numbers"
  puts ""
  puts "Tree Balanced: #{tree.balanced?}"
  puts ""
  puts "If tree is not balanced -> rebalance"
  puts ""
  tree.rebalance
  puts ""
  puts "Rebalancing complete"
  puts ""
  puts "Tree Balanced: #{tree.balanced?}"
  puts ""
  puts "New Tree:"
  tree.pretty_print
  puts ""
  tree.level_order
  puts ""
  puts "In order #{tree.inorder} "
  puts ""
  puts "Preorder #{tree.preorder}"
  puts ""
  puts "Postorder #{tree.postorder}"
end

driver