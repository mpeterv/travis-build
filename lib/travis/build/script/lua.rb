module Travis
  module Build
    class Script
      class Lua < Script
        DEFAULTS = {
          lua: '5.3'
        }

        def export
          super

          sh.export 'TRAVIS_LUA_VERSION', version, echo: false
        end

        def configure
          super

          sh.cmd "sudo sh -c 'pip install hererocks'"
        end

        def setup
          super

          sh.echo 'Lua for Travis-CI is not officially supported, ' \
                  'but is community maintained.', ansi: :green
          sh.echo 'Please file any issues using the following link',
                  ansi: :green
          sh.echo '  https://github.com/travis-ci/travis-ci/issues' \
                  '/new?labels=community:lua', ansi: :green
          sh.echo 'and mention \`@camoy\`, \`@mpeterv\`, and \`@\`'\
                  ' in the issue', ansi: :green

          unless lua_version_valid?
            sh.failure "\"#{version}\" is an invalid version of Lua.\nView valid versions of Lua at https://docs.travis-ci.com/user/languages/lua/"
          end

          sh.fold('lua-install') do
            if lua_version_valid?
              sh.echo 'Installing Lua', ansi: :yellow
              sh.cmd "hererocks $HOME/.lua -r^ --#{lua_hererocks_version}"
              sh.export 'PATH', '$HOME/.lua/bin:$PATH'
              sh.cmd 'luarocks install busted'
            end
          end
        end

        def announce
          super

          sh.cmd 'lua -v'
          sh.echo ''
        end

        def install
          sh.if '-f *.rockspec' do
            sh.cmd 'luarocks make'
          end
        end

        def script
          sh.cmd 'busted'
        end

        private

        def version
          config[:lua].to_s.shellescape
        end

        def lua_version_valid?
          !lua_hererocks_version.nil?
        end

        def lua_hererocks_version
          case version
          when '5.1' then 'lua=5.1'
          when '5.2' then 'lua=5.2'
          when '5.3' then 'lua=5.3'
          when 'luajit-2.0' then 'luajit=2.0'
          when 'luajit-2.1' then 'luajit=2.1'
          end
        end
      end
    end
  end
end
