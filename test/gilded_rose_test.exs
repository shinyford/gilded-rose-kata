defmodule GildedRoseTest do
  use ExUnit.Case

  test "quality decreases on update" do
    sausage = %Item{name: "Sausage", quality: 1, sell_in: 1}
    [updated_sausage] = GildedRose.update_quality([sausage])
    assert updated_sausage.quality == 0
    assert updated_sausage.sell_in == 0
  end

  test "quality decreases twice as fast after sold by date" do
    sausage = %Item{name: "Sausage", quality: 10, sell_in: -1}
    [updated_sausage] = GildedRose.update_quality([sausage])
    assert updated_sausage.quality == 8
  end

  test "quality is never negative" do
    sausage = %Item{name: "Sausage", quality: 0, sell_in: -1}
    [updated_sausage] = GildedRose.update_quality([sausage])
    assert updated_sausage.quality == 0

    sausage = %Item{name: "Sausage", quality: 1, sell_in: -1}
    [updated_sausage] = GildedRose.update_quality([sausage])
    assert updated_sausage.quality == 0
  end

  test "aged brie gets better" do
    aged_brie = %Item{name: "Aged Brie", quality: 10, sell_in: 10}
    [updated_aged_brie] = GildedRose.update_quality([aged_brie])
    assert updated_aged_brie.quality == 11
  end

  test "quality is never above 50" do
    sausage = %Item{name: "Sausage", quality: 100, sell_in: 10}
    [updated_sausage] = GildedRose.update_quality([sausage])
    assert updated_sausage.quality == 49
  end

  test "Sulfuras is magic and never changes" do
    sulfuras = %Item{name: "Sulfuras", quality: 1, sell_in: 1}
    [updated_sulfuras] = GildedRose.update_quality([sulfuras])
    assert updated_sulfuras.quality == 1
    assert updated_sulfuras.sell_in == :infinity
  end

  describe "backstage passes" do
    test "increase in quality" do
      backstage_pass = %Item{name: "Backstage Pass", quality: 10, sell_in: 20}
      [updated_backstage_pass] = GildedRose.update_quality([backstage_pass])
      assert updated_backstage_pass.quality == 11
    end

    test "increase double in quality when 5-10 days left" do
      backstage_pass = %Item{name: "Backstage Pass", quality: 10, sell_in: 10}
      [updated_backstage_pass] = GildedRose.update_quality([backstage_pass])
      assert updated_backstage_pass.quality == 12
    end

    test "increase triple in quality when 0-5 days left" do
      backstage_pass = %Item{name: "Backstage Pass", quality: 10, sell_in: 5}
      [updated_backstage_pass] = GildedRose.update_quality([backstage_pass])
      assert updated_backstage_pass.quality == 13
    end

    test "quality goes to zero when event passed" do
      backstage_pass = %Item{name: "Backstage Pass", quality: 10, sell_in: -1}
      [updated_backstage_pass] = GildedRose.update_quality([backstage_pass])
      assert updated_backstage_pass.quality == 0
    end
  end

  describe "conjured items" do
    test "quality decreases twice as fast" do
      conjured_sausage = %Item{name: "Conjured Sausage", quality: 10, sell_in: 10}
      [updated_conjured_sausage] = GildedRose.update_quality([conjured_sausage])
      assert updated_conjured_sausage.quality == 8
    end
  end
end
