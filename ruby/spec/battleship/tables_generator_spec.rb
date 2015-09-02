require 'spec_helper'

describe Battleship::TablesGenerator do
  describe '#ships' do
    it 'returns the unsunk ships' do
      ships = double('ships')
      tables_generator = Battleship::TablesGenerator.new(ships: ships)
      expect(tables_generator.ships).to eq ships
    end

    it 'returns empty array if there are none passed' do
      tables_generator = Battleship::TablesGenerator.new({})
      expect(tables_generator.ships).to be_empty
    end
  end

  describe '#misses' do
    it 'returns the misses ships' do
      misses = double('misses')
      tables_generator = Battleship::TablesGenerator.new(misses: misses)
      expect(tables_generator.misses).to eq misses
    end

    it 'returns empty array if there are none passed' do
      tables_generator = Battleship::TablesGenerator.new({})
      expect(tables_generator.misses).to be_empty
    end
  end

  describe '#hits' do
    it 'returns the hits ships' do
      hits = double('hits')
      tables_generator = Battleship::TablesGenerator.new(hits: hits)
      expect(tables_generator.hits).to eq hits
    end

    it 'returns empty array if there are none passed' do
      tables_generator = Battleship::TablesGenerator.new({})
      expect(tables_generator.hits).to be_empty
    end
  end

  describe '#sunk_pairs' do
    it 'returns the sunk_pairs ships' do
      sunk_pairs = double('sunk_pairs')
      tables_generator = Battleship::TablesGenerator.new(sunk_pairs: sunk_pairs)
      expect(tables_generator.sunk_pairs).to eq sunk_pairs
    end

    it 'returns empty array if there are none passed' do
      tables_generator = Battleship::TablesGenerator.new({})
      expect(tables_generator.sunk_pairs).to be_empty
    end
  end

  describe 'ship of length 2 in 3x3' do
    it 'abs_freqs should return the proper freqs' do
      ship_1 = Battleship::Ship.new(length: 2)
      ships = [ship_1]
      tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                         row_length: 3,
                                                         col_length: 3)

      abs_freqs = tables_generator.abs_freqs
      expect(abs_freqs).to eq [[2,3,2],[3,4,3],[2,3,2]]
      expect(tables_generator.num_total_configurations).to eq 12
    end

    describe 'user hits top corner' do
      it 'should calculate the right absolute frequencies' do
        ship_1 = Battleship::Ship.new(length: 2)
        hit_1 = Battleship::Point.new(row: 1, col: 1)
        ships = [ship_1]
        hits = [hit_1]
        tables_generator = Battleship::TablesGenerator.new(ships: ships,
                                                           hits: hits,
                                                           row_length: 3,
                                                           col_length: 3)

        abs_freqs = tables_generator.abs_freqs
        expect(abs_freqs).to eq [[0,1,0],[1,0,0],[0,0,0]]
        expect(tables_generator.num_total_configurations).to eq 2
      end
    end
  end

  describe '#ships_combinations' do
    describe 'when there is one horizontal ship of length 2' do
      it 'should only generate one combination' do
        ship_1 = Battleship::HorizontalShip.new(length: 2)
        ships = [ship_1]
        tables_generator = Battleship::TablesGenerator.new(ships: ships)

        expect(tables_generator.ships_combinations.first).to eq ship_1
      end
    end

    describe 'when there is one ship of length 2 and unspecified orientation' do
      it 'should generate two combinations' do
        ship_1 = Battleship::Ship.new(length: 2)
        ships = [ship_1]
        tables_generator = Battleship::TablesGenerator.new(ships: ships)

        first_combination = tables_generator.ships_combinations.first
        second_combination = tables_generator.ships_combinations[1]

        expect(tables_generator.ships_combinations.count).to eq 2
        expect(first_combination.count).to eq 1
        expect(first_combination[0].class).to eq Battleship::HorizontalShip
        expect(second_combination.count).to eq 1
        expect(second_combination[0].class).to eq Battleship::VerticalShip
      end
    end

    describe 'when there are two ships of unspecified orientation' do
      it 'should generate four combinations [H_x,H_y], [H_x, V_y], [V_x, H_y], [V_x, V_y]' do
        ship_1 = Battleship::Ship.new(length: 2)
        ship_2 = Battleship::Ship.new(length: 3)
        ships = [ship_1, ship_2]
        tables_generator = Battleship::TablesGenerator.new(ships: ships)

        combinations = tables_generator.ships_combinations
        first_combination = combinations.first
        second_combination = combinations[1]
        third_combination = combinations[2]
        fourth_combination = combinations[3]

        expect(combinations.length).to eq 4
        expect(first_combination.count).to eq 2
        expect(first_combination[0].class).to eq Battleship::HorizontalShip
        expect(first_combination[0].length).to eq 2
        expect(first_combination[1].class).to eq Battleship::HorizontalShip
        expect(first_combination[1].length).to eq 3

        expect(second_combination.count).to eq 2
        expect(second_combination[0].class).to eq Battleship::HorizontalShip
        expect(second_combination[0].length).to eq 2
        expect(second_combination[1].class).to eq Battleship::VerticalShip
        expect(second_combination[1].length).to eq 3

        expect(third_combination.count).to eq 2
        expect(third_combination[0].class).to eq Battleship::VerticalShip
        expect(third_combination[0].length).to eq 2
        expect(third_combination[1].class).to eq Battleship::HorizontalShip
        expect(third_combination[1].length).to eq 3

        expect(fourth_combination.count).to eq 2
        expect(fourth_combination[0].class).to eq Battleship::VerticalShip
        expect(fourth_combination[0].length).to eq 2
        expect(fourth_combination[1].class).to eq Battleship::VerticalShip
        expect(fourth_combination[1].length).to eq 3
      end
    end
  end
end
