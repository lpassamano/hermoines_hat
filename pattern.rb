# defines the knitting pattern and stitches
class Pattern
  ### VISUAL REPRESENTATION OF STITCHES ###
  def knit
    # visual representation of a knit stitch
    'V'
  end

  def purl
    # visual representation of a purl stitch
    '~'
  end

  def yarn_over
    # visual representation of passing the yarn over the needle
    'O'
  end

  def purl_2_together
    # visual representation of purling two stitches together
    # appears the same as #purl but is a different action while knitting, so
    # it is a separate method
    '~'
  end

  def knit_2_together
    # visual representation of knitting two stitches together
    # appears the same as #knit but is a different action while knitting, so
    # it is a separate method
    'V'
  end

  def cable_knit
    # visual representation of six stitch left leaning cable
    '\\'
  end

  ### METHODS THAT DEFINE THE HAT PATTERN ###
  def knit_pattern
    # main method to run the pattern and interact with user
    puts 'Welcome to the knitting machine! Today we are going to knit a hat.'

    stitches = get_hat_size
    current_row = 1
    hat = []

    puts "Great! Let's knit your hat!!!"
    knit_row(current_row, hat, stitches)
    decrease_row(current_row, hat, stitches)
    puts "\nYour hat is now complete!"
    puts ""
  end

  def get_hat_size
    # gets user input to determine the size of the hat/number of stitches
    puts 'What size should we make the hat? Please choose a multiple of 11 to cast on:'
    number = gets.chomp.to_i
    if number > 0 && number % 11 == 0
      number
    else
      get_hat_size
    end
  end

  def knit_row(current_row, hat, stitches)
    # uses the number of the current row to determine what pattern of stitches to knit
    # adds each new row as an array to the hat array
    puts "\nRow #{current_row}...\n\n"
    case current_row
    when 1, 2, 3, 4
      hat.unshift(rib_row(stitches))
    when 5, 6, 10, 12, 13, 17, 19
      hat.unshift(solid_row(stitches))
    when 7, 14
      hat.unshift(right_eyelet_row(stitches))
    when 8, 15
      hat.unshift(center_eyelet_row(stitches))
    when 9, 16
      hat.unshift(left_eyelet_row(stitches))
    when 11, 18
      hat.unshift(cable_row(stitches))
    end
    display_hat(hat)
    current_row += 1
    knit_row(current_row, hat, stitches) if current_row <= 19
  end

  def decrease_row(current_row, hat, stitches)
    # uses number of the current row to decrease the stitches in each row
    # adds each new row as an array to the hat array
    puts "\nRow #{current_row + 19}...\n\n"
    case current_row
    when 1, 2, 3, 4, 5
      row = hat[0].slice(0..-1)
      hat.unshift(decrease_purl_row(current_row, row, stitches))
    end
    display_hat(hat)
    current_row += 1
    decrease_row(current_row, hat, stitches) if current_row <= 5
  end

  def decrease_purl_row(current_row, row, stitches)
    # decreases the number of stitches in a row by removing a purl stitch
    decrease = (stitches / 11) * 2 - 1
    shift = (stitches / 11 / 2).to_f.ceil
    last_purl = decrease + (shift * (current_row - 1))

    while decrease >= 0
      row[last_purl] = row[last_purl].slice(0..-2)
      last_purl -= 2
      decrease -= 2
    end
    shift.times { row.unshift(' ') }
    row
  end

  def display_hat(hat)
    # prints the hat to terminal
    sleep(1)
    hat.each { |row| puts row.join('') }
  end

  def rib_row(stitches)
    # creates 1x1 rib (alternating knit and purl stitches)
    row = []
    while stitches >= 2
      row << knit
      row << purl
      stitches -= 2
    end
    if stitches == 1
      row << knit
    end
    row
  end

  def solid_row(stitches)
    # creates row that does not have cable or eyelet stitches
    row = []
    while stitches >= 10
      knit_sts = []
      purl_sts = []
      6.times { knit_sts << knit }
      5.times { purl_sts << purl }
      row << knit_sts
      row << purl_sts
      stitches -= 11
    end
    row
  end

  def right_eyelet_row(stitches)
    # creates row with eyelet on the right of the purl section
    row = []
    while stitches >= 11
      6.times { row << knit }
      3.times { row << purl }
      row << yarn_over
      row << purl_2_together
      stitches -= 11
    end
    row
  end

  def center_eyelet_row(stitches)
    # creates row with eyelet on the center of the purl section
    row = []
    while stitches >= 11
      6.times { row << knit }
      2.times { row << purl }
      row << yarn_over
      row << purl_2_together
      row << purl
      stitches -= 11
    end
    row
  end

  def left_eyelet_row(stitches)
    # creates row with eyelet on the left of the purl section
    row = []
    while stitches >= 11
      6.times { row << knit }
      row << purl
      row << yarn_over
      row << purl_2_together
      2.times { row << purl }
      stitches -= 11
    end
    row
  end

  def cable_row(stitches)
    # creates row with six left leaning knit stitches
    row = []
    while stitches >= 11
      6.times { row << cable_knit }
      5.times { row << purl }
      stitches -= 11
    end
    row
  end
end
