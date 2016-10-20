require 'item'

class GildedRose
  attr_reader :unique_items, :normal_items

  UNIQUE_ITEMS = ["Conjured", "Aged Brie", "Backstage passes to a TAFKAL80ETC concert", "Sulfuras, Hand of Ragnaros"]

  def initialize(items)
    @items = items
    @unique_items = []
    @normal_items = []
    filter_items
  end

  def update
    update_quality_normal
    update_sell_in_normal
    update_quality_unique
  end

  private

  def filter_items
    @items.each do |item|
      UNIQUE_ITEMS.include?(item.name) ? @unique_items << item : @normal_items << item
    end
  end

  def update_quality_normal
    @normal_items.each do |item|
      unless item.quality == 0
        item.sell_in > 0 ? item.quality -= 1 : item.quality -= 2
      end
    end
  end

  def update_sell_in_normal
    @normal_items.each do |item|
      item.sell_in -= 1
    end
  end

  def update_quality_unique()
    @unique_items.each do |item|
      case item.name
      when "Aged Brie" then update_brie(item)
      when "Backstage passes to a TAFKAL80ETC concert" then update_concert(item)
      when "Conjured" then update_conjured(item)
      end
    end
  end

  def update_brie(item)
    item.quality < 50 ? item.quality += 1 : item.quality = 50
    item.sell_in -= 1
  end

  def update_concert(item)
    if item.sell_in > 10 then item.quality += 1
    elsif item.sell_in <= 0 then item.quality = 0
    elsif item.sell_in <= 5 then item.quality += 3
    elsif item.sell_in < 11 then item.quality += 2
    end
    item.quality = 50 if item.quality >= 50
  end

  def update_conjured(item)
    if item.quality > 0 && item.sell_in > 0 then item.quality -= 2
    elsif item.quality > 0 && item.sell_in <= 0 then item.quality -= 4
    else item.quality = 0
    end
    item.sell_in -= 1
  end

end
