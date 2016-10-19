require 'spec_helper'
require 'gilded_rose'

describe GildedRose do
  # subject(:gilded_rose) { described_class.new(items) }
 #  let(:item) { double :item }
 #  let(:Item) { double :Item }
 #
 # before(:each) do
 #   allow(Item).to receive(:new) { item }
 # end



  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new("foo", 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq "foo"
    end

    context "general items - quality" do

      it "reduces quality by 1 at end of day if quality >0" do
        items = [Item.new("foo", 5, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end

      it "quality cannot be reduced below 0" do
        items = [Item.new("foo", 5, 0)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end

      it "can never have a quality greater than 50" do
        items = [Item.new("foo", 5, 51)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end
    end

    context "general items - sell in" do

      it "reduces sell_in by 1 at end of day" do
        items = [Item.new("foo", 5, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 4
      end

      it "sell_in can be negative" do
        items = [Item.new("foo", 0, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq -1
      end

      it "once sell by date has passed quality degrades twice as fast" do
        items = [Item.new("foo", 0, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end
    end

    context "Aged Brie" do

      it "quality of 'Aged Brie' cannot be increased over 50" do
        items = [Item.new("Aged Brie", 5, 50)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end

      it "quality of 'Aged Brie' increases rather than decreases" do
        items = [Item.new("Aged Brie", 5, 49)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end

      it "sell_in can be negative" do
        items = [Item.new("Aged Brie", 0, 1)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq -1
      end
    end

    context "Sulfuras" do

      it "quality is not decreased" do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 5)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 5
      end

      it "sell_in is not decreased" do
        items = [Item.new("Sulfuras, Hand of Ragnaros", 5, 5)]
        GildedRose.new(items).update_quality()
        expect(items[0].sell_in).to eq 5
      end
    end

    context "Backstage passes" do

      it 'quality increases by 1 when sell_in > 10' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 11, 5)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 6
      end

      it 'quality increases by 2 when sell_in <= 10' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 5)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 7
      end

      it 'quality increases by 3 when sell_in <= 5' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 5)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 8
      end

      it 'quality cannot increase beyond 50' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 49)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 50
      end

      it 'quality drops to 0 when sell_in past' do
        items = [Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 5)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end
    end



  end

end
