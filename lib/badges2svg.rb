module BadgesToSVG
  class << self

    ROOT = 'https://img.shields.io'

    # see http://shields.io/
    RULES = [
      { :name    => :travis_branch,
        :pattern => 'https?://travis-ci.org/%{user}/%{repo}.png' +
                      '\\?branch=%{branch}',
        :string  => '/travis/%{user}/%{repo}/%{branch}.svg'
      },
      {
        :name    => :travis,
        :pattern => 'https?://travis-ci.org/%{user}/%{repo}.png',
        :string  => '/travis/%{user}/%{repo}.svg'
      },
      {
        :name    => :gittip,
        :pattern => 'https?://img.shields.io/gittip/%{user}.png',
        :string  => '/gittip/%{user}.svg'
      },
      {
        :name    => :coveralls_branch,
        :pattern => 'https?://coveralls.io/repos/%{user}/%{repo}/badge.png' +
                      '\\?branch=%{branch}',
        :string  => '/coveralls/%{user}/%{repo}/%{branch}.svg'
      },
      {
        :name    => :coveralls,
        :pattern => 'https?://coveralls.io/repos/%{user}/%{repo}/badge.png',
        :string  => '/coveralls/%{user}/%{repo}.svg'
      },
      {
        :name    => :gemnasium,
        :pattern => 'https?://gemnasium.com/%{user}/%{repo}.png',
        :string  => '/gemnasium/%{user}/%{repo}.svg'
      },
      {
        :name    => :gem_version,
        :pattern => 'https?://badge.fury.io/rb/%{repo}.png',
        :string  => '/gem/v/%{repo}.svg'
      },

      {
        :name    => :misc_png,
        :pattern => 'https?://img.shields.io/%{path}.png',
        :string  => '/%{path}.svg'
      },
    ]

    def version
      '0.0.1'
    end

    def compile_pattern(pat, *a)
      pat = pat.gsub(/\./, '\\.')
      Regexp.new ("\\b#{pat.gsub(/%\{(\w+)\}/, "(?<\\1>.+?)")}\\b")
    end

    def replace ct
      content = ct.clone
      RULES.each do |r|
        content.gsub!(compile_pattern(r[:pattern]),
                      ROOT + r[:string].gsub(/%\{(\w+)\}/, "\\\\k<\\1>"))
      end

      content
    end

  end
end