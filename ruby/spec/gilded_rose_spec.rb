require 'spec_helper'
require 'gilded_rose'

describe GildedRose do

  describe "#filter_items" do
    # let(:sulfuras) { double :sulfuras, name: "Sulfuras, Hand of Ragnaros", sell_in: 5, quality: 5}
    # let(:normal) { double :normal, name: "foo", sell_in: 5, quality: 1 }

    it 'filters normal items based on name' do
      item1 = Item.new("Sulfuras, Hand of Ragnaros", 5, 5)
      item2 = Item.new("foo", 5, 0)
      items = [item1, item2]
      gilded_rose = GildedRose.new(items)
      expect(gilded_rose.normal_items).to eq([item2])
    end
  end

  describe "#update" do
    #Not sure how to get doubles to work!!!!
    # let(:normal) { double :normal, name: "foo", sell_in: 5, quality: 5 }

    it "does not change the name" do
      items = [Item.new("foo", 5, 0)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.normal_items[0].name).to eq "foo"
    end


  context '#update_quality_normal' do
    # let(:sulfuras) { double :sulfuras, name: "Sulfuras, Hand of Ragnaros", sell_in: 5, quality: 5}
    # let(:normal) { double :normal, name: "foo", sell_in: 5, quality: 0 }

    it 'if quality > 0 deducts 1 from normal items' do
      item1 = Item.new("Sulfuras, Hand of Ragnaros", 5, 5)
      item2 = Item.new("foo", 5, 0)
      items = [item1, item2]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.normal_items[0].quality).to eq 0
    end

    it "quality cannot be reduced below 0" do
      items = [Item.new("foo", 5, 0)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.normal_items[0].quality).to eq 0
    end

    it "can never have a quality greater than 50" do
      items = [Item.new("foo", 5, 51)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.normal_items[0].quality).to eq 50
    end

    it "once sell by date has passed quality degrades twice as fast" do
      items = [Item.new("foo", 0, 2)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.normal_items[0].quality).to eq 0
    end

  end

  context '#update_sell_in_normal' do

    it "reduces sell_in by 1 at end of day" do
      items = [Item.new("foo", 5, 1)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.normal_items[0].sell_in).to eq 4
    end

    it "sell_in can be negative" do
      items = [Item.new("foo", 0, 1)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.normal_items[0].sell_in).to eq -1
    end
  end

  context "#update_brie" do

    it "quality of 'Aged Brie' cannot be increased over 50" do
      items = [Item.new("Aged Brie", 5, 50)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 50
    end

    it "quality of 'Aged Brie' increases rather than decreases" do
      items = [Item.new("Aged Brie", 5, 49)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 50
    end

    it "sell_in can be negative" do
      items = [Item.new("Aged Brie", 0, 1)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].sell_in).to eq -1
    end
  end

  context "#update_concert" do

    it 'quality increases by 1 when sell_in > 10' do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 5)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 6
    end

    it 'quality increases by 2 when sell_in < 11 & Quality is less than 50' do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 5)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq  7
    end

    it 'quality increases by 3 when sell_in <= 5' do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 5)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 8
    end

    it 'quality cannot increase beyond 50' do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 49)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 50
    end

    it 'quality drops to 0 when sell_in past' do
      items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 5)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 0
    end
  end

  context "Sulfuras" do

    it "quality is not decreased" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 5)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 5
    end

    it "sell_in is not decreased" do
      items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 5)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].sell_in).to eq 5
    end
  end

  context "update_conjured" do
    it "quality decreases by 2 each day" do
      items = [Item.new("Conjured", 10, 10)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 8
    end

    it "sell_in can be negative" do
      items = [Item.new("Conjured", 0, 10)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].sell_in).to eq -1
    end

    it "quality cannot be reduced below 0" do
      items = [Item.new("Conjured", 10, 0)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 0
    end

    it "once sell by date has passed quality degrades twice as fast" do
      items = [Item.new("Conjured", 0, 10)]
      gilded_rose = GildedRose.new(items)
      gilded_rose.update
      expect(gilded_rose.unique_items[0].quality).to eq 6
    end
  end

end

end
