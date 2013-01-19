#   Copyright (C) 2006  Andrea Censi  <andrea (at) rubyforge.org>
#
# This file is part of Maruku.
#
#   Maruku is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   Maruku is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with Maruku; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


module MaRuKu
  class MDElement
    INSPECT_FORMS = {
      :paragraph          => ["par",      :children],
      :footnote_reference => ["foot_ref", :footnote_id],
      :entity             => ["entity",   :entity_name],
      :email_address      => ["email",    :email],
      :inline_code        => ["code",     :raw_code],
      :raw_html           => ["html",     :raw_html],
      :emphasis           => ["em",       :children],
      :strong             => ["strong",   :children],
      :immediate_link     => ["url",      :url],
      :image              => ["image",    :children, :ref_id],
      :im_image           => ["im_image", :children, :url, :title],
      :link               => ["link",     :children, :ref_id],
      :im_link            => ["im_link",  :children, :url, :title],
      :ref_definition     => ["ref_def",  :ref_id, :url, :title],
      :ial                => ["ial",      :ial],
      :li                 => ["li",       :children, :want_my_paragraph]
    }

    # Outputs the document AST as calls to document helpers.
    # (this should be `eval`-able to get a copy of the original element).
    def inspect
      if INSPECT_FORMS.has_key? @node_type
        name, *params = INSPECT_FORMS[@node_type]

        params = params.map do |p|
          if p == :children
            children_inspect
          else
            send(p).inspect
          end
        end
        params << @al.inspect if @al && !@al.empty?
      else
        name = 'el'
        params = [self.node_type.inspect, children_inspect]
        params << @meta_priv.inspect unless @meta_priv.empty? && self.al.empty?
        params << self.al.inspect unless self.al.empty?
      end

      "md_#{name}(#{params.join(', ')})"
    end

    private

    def children_inspect
      kids = @children.map(&:inspect)
      return kids.first if kids.size == 1

      comma = kids.join(", ")
      if comma.size < 70
        "[#{comma}]"
      else
        "[\n\t#{kids.join(",\n\t")}\n]"
      end
    end
  end
end
