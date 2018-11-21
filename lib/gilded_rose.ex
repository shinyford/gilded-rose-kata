defmodule GildedRose do
  # Example
  # update_quality([%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 1}])
  # => [%Item{name: "Backstage passes to a TAFKAL80ETC concert", sell_in: 9, quality: 3}]

  def update_quality(items) do
    Enum.map(items, &update_item/1)
  end

  def update_item(item) do
    %{item | quality: updated_quality(item), sell_in: updated_sell_in(item)}
  end

  def updated_quality(%{name: "Sulfuras", quality: quality}), do: quality
  def updated_quality(%{quality: quality} = item) when quality > 50 do
    updated_quality(%{item | quality: 50})
  end
  def updated_quality(%{quality: 0}), do: 0
  def updated_quality(%{name: "Backstage Pass", sell_in: sell_in})
   when sell_in < 0, do: 0
  def updated_quality(%{quality: quality, sell_in: sell_in})
   when sell_in < 0 and quality <= 1, do: 0
  def updated_quality(%{quality: quality, sell_in: sell_in} = item)
    when sell_in < 0, do: quality + (2 * quality_modifier(item))
  def updated_quality(%{quality: quality} = item) do
    quality + quality_modifier(item)
  end

  def updated_sell_in(%{name: "Sulfuras"}), do: :infinity
  def updated_sell_in(%{sell_in: sell_in}), do: sell_in - 1

  def quality_modifier(%{name: "Conjured " <> name} = item) do
    2 * quality_modifier(%{item | name: name})
  end
  def quality_modifier(%{name: "Aged Brie"}), do: 1
  def quality_modifier(%{name: "Backstage Pass", sell_in: sell_in})
    when sell_in > 10, do: 1
  def quality_modifier(%{name: "Backstage Pass", sell_in: sell_in})
    when sell_in > 5, do: 2
  def quality_modifier(%{name: "Backstage Pass"}), do: 3
  def quality_modifier(_), do: -1
end
