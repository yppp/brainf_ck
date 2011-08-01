# -*- encoding:utf-8 -*-

class Brainfuck
  def initialize(src)
    @souce = src
    @program = []
    @tape = []
    @jmptab = {}
    @pc = 0
    @cur = 0
  end

  def compile
    stack = []

    @program = @souce.chars.map.with_index do |x, y|

      case x
        when '+'
        :inc
        when '-'
        :dec
        when '>'
        :next
        when '<'
        :prev
        when '['
        stack.push y
        :lb
        when ']'
        r = stack.pop
        raise "]が多すぎます" if r.nil?
        @jmptab[y] = r
        @jmptab[r] = y
        :rb
        when '.'
        :dot
        when ','
        :cor
      end

    end

    raise "[が多すぎます" unless stack.empty?
  end

  def exec
    until @program[@pc].nil?
      @tape[@cur] ||= 0
      case @program[@pc]
      when :inc
        @tape[@cur] += 1
      when :dec
        @tape[@cur] -= 1
      when :next
        @cur += 1
      when :prev
        @cur -= 1
      when :lb
        if @tape[@cur] == 0 then
          @pc = @jmptab[@pc]
        end
      when :rb
        if @tape[@cur] != 0 then
          @pc = @jmptab[@pc]
        end
      when :dot
        print @tape[@cur].chr
      when :cor    
        $stdin.getc
      end
      @pc += 1
    end
  end
end

bf = Brainfuck::new "+++++++++[>+++++++++[<[>>+>+<<<-]>>>[<<<+>>>-]<.><<-]>[-]<<-]"
bf.compile
bf.exec
