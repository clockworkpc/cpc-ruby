module Cpc
  module Util
    module PleasingPrintUtil
      def x11_colors
        %w[aliceblue antiquewhite aqua aquamarine azure beige bisque blanchedalmond blueviolet brown burlywood cadetblue chartreuse chocolate coral cornflower cornsilk crimson darkblue darkcyan darkgoldenrod darkgray darkgreen darkkhaki darkmagenta darkolivegreen darkorange darkorchid darkred darksalmon darkseagreen darkslateblue darkslategray darkturquoise darkviolet deeppink deepskyblue dimgray dodgerblue firebrick floralwhite forestgreen fuchsia gainsboro ghostwhite gold goldenrod gray greenyellow honeydew hotpink indianred indigo ivory khaki lavender lavenderblush lawngreen lemonchiffon lightblue lightcoral lightcyan lightgoldenrod lightgray lightgreen lightpink lightsalmon lightseagreen lightskyblue lightslategray lightsteelblue lightyellow lime limegreen linen maroon mediumaquamarine mediumblue mediumorchid mediumpurple mediumseagreen mediumslateblue mediumspringgreen mediumturquoise mediumvioletred midnightblue mintcream mistyrose moccasin navajowhite navyblue oldlace olive olivedrab orange orangered orchid palegoldenrod palegreen paleturquoise palevioletred papayawhip peachpuff peru pink plum powderblue purple rebeccapurple rosybrown royalblue saddlebrown salmon sandybrown seagreen seashell sienna silver skyblue slateblue slategray snow springgreen steelblue tan teal thistle tomato turquoise violet webgray webgreen webmaroon webpurple wheat whitesmoke yellowgreen].map {|str| str.to_sym}
      end

      def ansi_colors
        %w[red green yellow blue magenta cyan white].map { |str| str.to_sym }
      end

      def primitives
        [
          String,
          Float,
          Integer,
          BigNumber,
          Symbol
        ]
      end

      def pleasing_print_hash(hsh, color_str = 'green', interval_fr = 0.01)
        hsh.each do |k, v|
          puts "#{Rainbow(k).color(:yellow)}: #{Rainbow(v).color(color_str.to_sym)}"
          sleep interval_fr
        end
      end

      def pleasing_print_array(ary, color_str = 'green', interval_fr = 0.01)
        ary.each do |n|
          puts "#{Rainbow(n).color(color_str.to_sym)}"
        end
      end

      def pleasing_print_hash_array(hsh_ary, color_str = 'green', interval_fr = 0.01)
        hsh_ary.each do |hsh|
          pleasing_print_hash(hsh)
        end
      end

      def pleasing_print_array_array(ary_ary, color_str = 'green', interval_fr = 0.01)
        ary_ary.each do |ary|
          pleasing_print_array(ary)
        end
      end

      def default_pleasing_print(enum_obj)
        case
        when hash_array?(enum_obj)
          pleasing_print_hash_array(enum_obj)
        when array_array?(enum_obj)
          pleasing_print_array_array(enum_obj)
        when hash?(enum_obj)
          pleasing_print_hash(enum_obj)
        when array?(enum_obj)
          pleasing_print_array(enum_obj)
        end
      end
    end
  end
end
