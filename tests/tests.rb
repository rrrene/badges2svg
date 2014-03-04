#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'coveralls'
Coveralls.wear!

require 'test/unit'
require 'simplecov'

test_dir = File.expand_path( File.dirname(__FILE__) )

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start { add_filter '/tests/' }

require 'badges2svg'

for t in Dir.glob( File.join( test_dir,  '*_tests.rb' ) )
  require t
end

class BadgesToSVGTests < Test::Unit::TestCase

  # == BadgesToSVG#version == #

  def test_version
    assert(BadgesToSVG.version =~ /^\d+\.\d+\.\d+/)
  end

  # == BadgesToSVG#compile_pattern == #

  def test_compile_pattern_empty
    assert_equal(/\b\b/, BadgesToSVG.compile_pattern(""))
  end

  def test_compile_pattern_no_special_chars
    assert_equal(/\bfoobar\b/, BadgesToSVG.compile_pattern("foobar"))
    assert_equal(/\bq-a yo\b/, BadgesToSVG.compile_pattern("q-a yo"))
  end

  def test_compile_pattern_with_special_chars
    assert_equal(/\bfoo\.bar\b/, BadgesToSVG.compile_pattern("foo.bar"))
    assert_equal(/\ba?\b/, BadgesToSVG.compile_pattern("a?"))
  end

  def test_compile_pattern_with_one_field_name
    assert_equal(/\b(?<abc>.+?)\b/, BadgesToSVG.compile_pattern("%{abc}"))
    assert_equal(/\ba?\b/, BadgesToSVG.compile_pattern("a?"))
  end

  def test_compile_pattern_with_multiple_field_names
    assert_equal(/\b(?<a>.+?)\/(?<b>.+?)\b/,
                 BadgesToSVG.compile_pattern("%{a}/%{b}"))
  end

  # == BadgesToSVG#replace == #

  def test_replace_empty_file
    assert_equal("", BadgesToSVG.replace(""))
  end

  def test_replace_simple_file
    ct = "# README\n\nHello World!"
    assert_equal(ct, BadgesToSVG.replace(ct))
  end

  ## travis

  def test_replace_one_travis_https
    ct1 = "# README\n\nHello ![](https://travis-ci.org/usr/re.png)"
    ct2 = "# README\n\nHello ![](https://img.shields.io/travis/usr/re.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_travis_http
    ct1 = "# README\n\nHello ![](http://travis-ci.org/usr/re.png)"
    ct2 = "# README\n\nHello ![](https://img.shields.io/travis/usr/re.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  ## travis_branch

  def test_replace_one_travis_branch_https
    ct1 = "# README\n\nHello ![](https://travis-ci.org/usr/re.png?branch=bx)"
    ct2 = "# README\n\nHello ![](https://img.shields.io/travis/usr/re/bx.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_travis_branch_http
    ct1 = "# README\n\nHello ![](http://travis-ci.org/usr/re.png?branch=aa)"
    ct2 = "# README\n\nHello ![](https://img.shields.io/travis/usr/re/aa.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  ## gittip

  def test_replace_one_gittip_http
    ct1 = "here is a badge: ![](http://img.shields.io/gittip/sferik.png)"
    ct2 = "here is a badge: ![](https://img.shields.io/gittip/sferik.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_gittip_https
    ct1 = "here is a badge: ![](https://img.shields.io/gittip/sferik.png)"
    ct2 = "here is a badge: ![](https://img.shields.io/gittip/sferik.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  ## coveralls

  def test_replace_one_coveralls_http
    ct1 = "hello ![](http://coveralls.io/repos/sferik/t/badge.png)"
    ct2 = "hello ![](https://img.shields.io/coveralls/sferik/t.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_coveralls_https
    ct1 = "hello ![](https://coveralls.io/repos/sferik/t/badge.png)"
    ct2 = "hello ![](https://img.shields.io/coveralls/sferik/t.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  ## coveralls_branch

  def test_replace_one_coveralls_branch_http
    ct1 = "hello ![](http://coveralls.io/repos/sferik/t/badge.png?branch=abc)"
    ct2 = "hello ![](https://img.shields.io/coveralls/sferik/t/abc.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_coveralls_branch_https
    ct1 = "hello ![](https://coveralls.io/repos/sferik/t/badge.png?branch=abc)"
    ct2 = "hello ![](https://img.shields.io/coveralls/sferik/t/abc.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  ## gem_version

  def test_replace_one_gem_version_http
    ct1 = "![](http://badge.fury.io/rb/t.png)"
    ct2 = "![](https://img.shields.io/gem/v/t.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_gem_version_https
    ct1 = "![](https://badge.fury.io/rb/t.png)"
    ct2 = "![](https://img.shields.io/gem/v/t.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  ## gemnasium

  def test_replace_one_gemnasium_http
    ct1 = "![](http://gemnasium.com/sferik/t.png)"
    ct2 = "![](https://img.shields.io/gemnasium/sferik/t.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_gemnasium_https
    ct1 = "![](https://gemnasium.com/sferik/t.png)"
    ct2 = "![](https://img.shields.io/gemnasium/sferik/t.svg)"
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  ## misc

  def test_replace_misc_png_http
    ct1 = "![](http://img.shields.io/foo/bar-qux/zzz.png)"
    ct2 = ct1.sub(/\.png/, '.svg').sub(/http:/, 'https:')
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_misc_png_https
    ct1 = "![](https://img.shields.io/foo/bar-qux/zzz.png)"
    ct2 = ct1.sub(/\.png/, '.svg').sub(/http:/, 'https:')
    assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

end


exit Test::Unit::AutoRunner.run