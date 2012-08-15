# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create({:title => 'Aladdin',         :rating => 'G',       :release_date => '25-Nov-1992'});
    Movie.create({:title => 'The Terminator',  :rating => 'R',       :release_date => '26-Oct-1984'});
    Movie.create({:title => 'When Harry Met Sally', :rating => 'R',  :release_date => '21-Jul-1989'});
    Movie.create({:title => 'The Help',        :rating => 'PG-13',   :release_date => '10-Aug-2011'});
    Movie.create({:title => 'Chocolat',        :rating => 'PG-13',   :release_date => '5-Jan-2001'});
    Movie.create({:title => 'Amelie',          :rating => 'R',       :release_date => '25-Apr-2001'});
    Movie.create({:title => '2001: A Space Odyssey', :rating => 'G', :release_date => '6-Apr-1968'});
    Movie.create({:title => 'The Incredibles', :rating => 'PG',      :release_date => '5-Nov-2004'});
    Movie.create({:title => 'Raiders of the Lost Ark', :rating => 'PG', :release_date => '12-Jun-1981'});
    Movie.create({:title => 'Chicken Run ',    :rating => 'G',       :release_date => '21-Jun-2000'});
  end
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").each do |field|
    field = field.strip
    if uncheck == "un"
       step %Q{I uncheck "ratings_#{field}"}
       step %Q{the "ratings_#{field}" checkbox should not be checked}
    else
      step %Q{I check "ratings_#{field}"}
      step %Q{the "ratings_#{field}" checkbox should be checked}
    end
  end
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