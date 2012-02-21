require 'spec_helper'

describe 'WithFilters::ActiveRecordModelExtention' do
  describe '#with_filters(params = nil, options = {})' do
    context 'filters using fields' do
      context 'field value is a string' do
        it 'filters based on the string value' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {first_name: 'Albert'}})
          npw.length.should == 1
          npw.first.first_name.should == 'Albert'
        end

        it 'skips an empty value' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {first_name: ''}})
          npw.where_values.should == []
        end
      end

      context 'field value is an array' do
        it 'filters based on the array values' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {first_name: ['Albert', 'Marie']}}).order('first_name ASC')
          npw.length.should == 2
          npw.first.first_name.should == 'Albert'
          npw.last.first_name.should == 'Marie'
        end

        it 'skips blank array values' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {first_name: ['Albert', 'Marie', '']}}).order('first_name ASC')
          npw.length.should == 2
          npw.first.first_name.should == 'Albert'
          npw.last.first_name.should == 'Marie'
          npw.where_values.should == ["nobel_prize_winners.\"first_name\" LIKE 'Albert' OR nobel_prize_winners.\"first_name\" LIKE 'Marie'"]
        end

        it 'skips empty arrays' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {first_name: []}})
          npw.where_values.should == []
        end
      end

      context 'field value is a :start and :stop range' do
        it 'filters between :start and :stop' do
          np = NobelPrize.with_filters({nobel_prizes: {year: {start: 1900, stop: 1930}}})
          np.length.should == 4
        end

        it 'discards the range if :start or :stop are empty' do
          np = NobelPrize.with_filters({nobel_prizes: {year: {start: 1900, stop: ''}}})
          np.where_values.should == []

          np = NobelPrize.with_filters({nobel_prizes: {year: {stop: 1930}}})
          np.where_values.should == []
        end
      end

      context 'field value is a boolean (and the column on the table is a :boolean)' do
        it 'filters when "true" and "false" are passed' do
          np = NobelPrize.with_filters({nobel_prizes: {shared: 'true'}})
          np.length.should == 7

          np = NobelPrize.with_filters({nobel_prizes: {shared: 'false'}})
          np.length.should == 9
        end
      end

      context 'field value is a date' do
        context 'and the column on the table is a :date' do
          it 'filters on the date value' do
            npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {birthdate: '19140325'}})
            npw.length.should == 1
            npw.first.birthdate.should == '19140325'.to_date
          end
        end

        context 'and the column on the table is a :datetime or :timestamp' do
          it 'filters on the date value' do
            date = '2012-01-01'
            npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {created_at: date}})
            npw.length.should == 5
            npw.first.created_at.to_s.should =~ /^#{date}/
            npw.last.created_at.to_s.should =~ /^#{date}/
          end
        end
      end

      context 'field value is a date range' do
        context 'and the column on the table is a :date' do
          it 'filters between :start and :stop' do
            npw = NobelPrizeWinner.
              with_filters({nobel_prize_winners: {birthdate: {start: '19140325', stop: '19280406'}}}).
              order('birthdate ASC')
            npw.length.should == 4
            npw.first.birthdate.should == '19140325'.to_date
            npw.last.birthdate.should == '19280406'.to_date
          end
        end

        context 'and the column on the table is a :datetime or :timestamp' do
          it 'filters between :start and :stop' do
            start_date = '2012-01-01'
            stop_date  = '2012-01-02'
            npw = NobelPrizeWinner.
              with_filters({nobel_prize_winners: {created_at: {start: start_date, stop: stop_date}}}).
              order('created_at ASC')
            npw.length.should == 10
            npw.first.created_at.to_s.should =~ /^#{start_date}/
            npw.last.created_at.to_s.should =~ /^#{stop_date}/
          end
        end
      end

      context 'field value is a datetime (and the column on the table is a :datetime or :timestamp)' do
        it 'filters on the datetime value' do
          time = '20120101120101'
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {created_at: time}})
          npw.length.should == 1
          npw.first.created_at.to_s.should == Time.parse(time).to_s
        end
      end

      context 'field value is a datetime range (and the column on the table is a :datetime or :timestamp)' do
        it 'filters between :start and :stop' do
          start_time = '20120101120101'
          stop_time  = '20120101120104'
          npw = NobelPrizeWinner.
            with_filters({nobel_prize_winners: {created_at: {start: start_time, stop: stop_time}}}).
            order('created_at ASC')
          npw.length.should == 4
          npw.first.created_at.to_s.should == Time.parse(start_time).to_s
          npw.last.created_at.to_s.should == Time.parse(stop_time).to_s
        end
      end

      it 'accepts more than one field' do
        np = NobelPrize.with_filters({nobel_prizes: {year: {start: 1900, stop: 1930}, category: 'Physics'}})
        np.length.should == 3
      end
    end

    context 'options' do
      context ':param_namespace' do
        it 'finds the params from the hash using the namespace' do
          npw = NobelPrizeWinner.with_filters({foo: {first_name: 'Albert'}}, {param_namespace: :foo})
          npw.with_filters_data[:param_namespace].should == :foo
        end 
      end
      context 'no :param_namespace' do
        it 'defaults to the primary table name' do
          npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {first_name: 'Albert'}})
          npw.with_filters_data[:param_namespace].should == :nobel_prize_winners
        end 
      end

      context ':fields' do
        context 'value is a hash of options' do
          context ':column' do
            it 'uses the passed column name' do
              npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {fname: 'Albert'}}, {
                fields: {
                  fname: {column: :first_name}
                }
              })
              npw.length.should == 1
              npw.first.first_name.should == 'Albert'

              npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {fname: 'Albert'}}, {
                fields: {
                  fname: {column: 'nobel_prize_winners.first_name'}
                }
              })
              npw.length.should == 1
              npw.first.first_name.should == 'Albert'
            end
          end

          context ':match' do
            context ':exact' do
              it 'handles matches for a single entry' do
                npw = NobelPrizeWinner.with_filters(
                  {nobel_prize_winners: {first_name: 'Paul'}},
                  {fields: {
                    first_name: {match: :exact}
                  }}
                ).order('first_name ASC')
                npw.length.should == 2
                npw.each do |n|
                  n.first_name.should == 'Paul'
                end
              end

              it 'handles matches for a multiple entries' do
                npw = NobelPrizeWinner.with_filters(
                  {nobel_prize_winners: {first_name: ['Paul', 'Erwin']}},
                  {fields: {
                    first_name: {match: :exact}
                  }}
                ).order('first_name ASC')
                npw.length.should == 3
                npw.first.first_name.should == 'Erwin'
                npw.second.first_name.should == 'Paul'
                npw.last.first_name.should == 'Paul'
              end
            end

            context ':contains' do
              it 'handles matches for a single entry' do
                npw = NobelPrizeWinner.with_filters(
                  {nobel_prize_winners: {first_name: 'el'}},
                  {fields: {
                    first_name: {match: :contains}
                  }}
                ).order('first_name ASC')
                npw.length.should == 3
                npw.first.first_name.should == 'Nelson'
                npw.second.first_name.should == 'Niels'
                npw.last.first_name.should == 'Samuel'
              end

              it 'handles matches for a multiple entries' do
                npw = NobelPrizeWinner.with_filters(
                  {nobel_prize_winners: {first_name: ['ert', 'mu'] }},
                  {fields: {
                    first_name: {match: :contains}
                  }}
                ).order('first_name ASC')
                npw.length.should == 3
                npw.first.first_name.should == 'Albert'
                npw.second.first_name.should == 'Bertrand'
                npw.last.first_name.should == 'Samuel'
              end
            end

            context ':begins_with' do
              it 'handles matches for a single entry' do
                npw = NobelPrizeWinner.with_filters(
                  {nobel_prize_winners: {first_name: 'ja'}},
                  {fields: {
                    first_name: {match: :begins_with}
                  }}
                ).order('first_name ASC')
                npw.length.should == 2
                npw.first.first_name.should == 'Jacques'
                npw.last.first_name.should == 'James'
              end

              it 'handles matches for a multiple entries' do
                npw = NobelPrizeWinner.with_filters(
                  {nobel_prize_winners: {first_name: ['ja', 'ri']}},
                  {fields: {
                    first_name: {match: :begins_with}
                  }}
                ).order('first_name ASC')
                npw.length.should == 3
                npw.first.first_name.should == 'Jacques'
                npw.second.first_name.should == 'James'
                npw.last.first_name.should == 'Richard'
              end
            end

            context ':ends_with' do
              it 'handles matches for a single entry' do
                npw = NobelPrizeWinner.with_filters(
                  {nobel_prize_winners: {first_name: 'es'}},
                  {fields: {
                    first_name: {match: :ends_with}
                  }}
                ).order('first_name ASC')
                npw.length.should == 2
                npw.first.first_name.should == 'Jacques'
                npw.last.first_name.should == 'James'
              end

              it 'handles matches for a multiple entries' do
                npw = NobelPrizeWinner.with_filters(
                  {nobel_prize_winners: {first_name: ['es', 'ie']}},
                  {fields: {
                    first_name: {match: :ends_with}
                  }}
                ).order('first_name ASC')
                npw.length.should == 3
                npw.first.first_name.should == 'Jacques'
                npw.second.first_name.should == 'James'
                npw.last.first_name.should == 'Marie'
              end
            end
          end
        end

        context 'value is a Proc' do
          it 'returns the value from the proc' do
            npw = NobelPrizeWinner.with_filters(
              {nobel_prize_winners: {full_name: 'Albert Einstein'}},
              {fields: {
                full_name: ->(value, scope) {
                  first_word, second_word = value.strip.split(/\s+/)

                  if second_word
                    scope.where(['first_name LIKE ? OR last_name LIKE ?', first_word, first_word])
                  else
                    scope.where(['first_name LIKE ? AND last_name LIKE ?', first_word, second_word])
                  end
                }
              }}
            )
            npw.length.should == 1
            npw.first.first_name.should == 'Albert'
            npw.first.last_name.should == 'Einstein'
          end
        end
      end
    end

    context 'provides with_filters_data attr' do
      it 'has :param_namespace' do
        npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {first_name: 'Albert'}})
        npw.with_filters_data[:param_namespace].should == :nobel_prize_winners
      end

      it 'stays when converted to an array' do
        npw = NobelPrizeWinner.with_filters({nobel_prize_winners: {first_name: 'Albert'}}).to_a
        npw.with_filters_data[:param_namespace].should == :nobel_prize_winners
      end
    end

    context 'limit the need for specifying table names to resolve ambiguity' do
      it 'prepends the table name to the field if the field is in the primary table' do
        npw = NobelPrizeWinner.joins(:nobel_prizes).with_filters({nobel_prize_winners: {birthdate: '19140325'}})
        npw.where_values.first.should =~ /^#{npw.table_name}\./
      end 

      it 'does not affect non-primary fields' do
        npw = NobelPrizeWinner.joins(:nobel_prizes).with_filters({nobel_prize_winners: {year: '1903'}})
        npw.where_values.first.should =~ /^#{npw.connection.quote_column_name('year')}/
      end 
    end

    it 'quotes column names' do
      npw = NobelPrizeWinner.joins(:nobel_prizes).with_filters({nobel_prize_winners: {year: '1903'}})
      npw.where_values.first.should =~ /^#{npw.connection.quote_column_name('year')}/
    end

    it 'does not break the chain' do
      npw = NobelPrizeWinner.with_filters.limit(1)
      npw.length.should == 1
    end
  end
end
