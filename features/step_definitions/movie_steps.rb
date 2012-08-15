# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  Movie.delete_all
  movies_table.hashes.each do |movie|
    Movie.create({title:'Aladdin', rating: 'G', release_date: '25-Nov-1992'})
    Movie.create({title:'The Terminator', rating: 'R', release_date: '26-Oct-1984'})
    Movie.create({title:'When Harry Met Sally', rating: 'R', release_date: '21-Jul-1989'})
    Movie.create({title:'The Help', rating: 'PG-13', release_date: '10-Aug-2011'})
    Movie.create({title:'Chocolat', rating: 'PG-13', release_date: '5-Jan-2001'})
    Movie.create({title:'Amelie', rating: 'R', release_date: '25-Apr-2001'})
    Movie.create({title:'2001: A Space Odyssey', rating: 'G', release_date: '6-Apr-1968'})
    Movie.create({title:'The Incredibles', rating: 'PG', release_date: '5-Nov-2004'})
    Movie.create({title:'Raiders of the Lost Ark', rating: 'PG', release_date: '12-Jun-1981'})
    Movie.create({title:'Chicken Run ', rating: 'G', release_date: '21-Jun-2000'})
  end
end

When /I (un)?check the following ratings: (.*)/ do |prefix, rating_list|
  rating_list.split(",").each do |field|
    field = field.strip
    step %Q{I #{prefix}check "ratings_#{field}"}
    step %Q{the "ratings_#{field}" checkbox should #{add_prefix(prefix)}be checked}
  end
end

def add_prefix(prefix)
  (prefix == "un") ? 'not ' : nil
end

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  titles = page.all("table#movies tbody tr td[1]").map {|t| t.text}
  assert titles.index(e1) < titles.index(e2)
end

Then /^I should see the following ratings: (.*)/ do |rating_list|
  ratings = page.all("table#movies tbody tr td[2]").map {|t| t.text}
  rating_list.split(",").each do |field|
    assert ratings.include?(field.strip)
  end
end

Then /^I should not see the following ratings: (.*)/ do |rating_list|
  ratings = page.all("table#movies tbody tr td[2]").map {|t| t.text}
  rating_list.split(",").each do |field|
    assert !ratings.include?(field.strip)
  end
end

Then /^I should see all of the movies$/ do
  rows = page.all("table#movies tbody tr td[1]").map {|t| t.text}
  assert rows.size == Movie.all.count
end

Then /^I should see no movies$/ do
  rows = page.all("table#movies tbody tr td[1]").map {|t| t.text}
  assert rows.size == 0
end

Then /I should(n't)? see: (.*)/ do |present, title_list|
  titles = title_list.split(", ")
  titles.each do |title|
    if page.respond_to? :should
      if present then
        page.should have_content(title)
      else
        page.should have_content(title) == false
      end
    else
      if present then
        assert page.has_content?(title)
      else
        assert page.has_content?(title) == false
      end
    end
  end
end

module Enumerable
  def sorted?
    each_cons(2).all? { |a, b| (a <=> b) <= 0 }
  end
end

Then /^the movies should be sorted by (.+)$/ do |sort_field|
  col_index = case sort_field
    when "title" then 0
    when "release_date" then 2
    else raise ArgumentError
  end

  values = all("table#movies tbody tr").map { |row| row.all("td")[col_index].text }
  false #assert values.sorted?
end
