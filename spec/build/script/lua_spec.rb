require 'spec_helper'

describe Travis::Build::Script::Lua, :sexp do
  let(:data)   { payload_for(:push, :lua) }
  let(:script) { described_class.new(data) }
  subject      { script.sexp }

  it_behaves_like 'a build script sexp'

  it "announces `lua -v`" do
    should include_sexp [:cmd, "lua -v", echo: true]
  end

  it "runs tests by default" do
    should include_sexp [:cmd, "busted", echo: true, timing: true]
  end

  context "versions" do
    it "installs Lua 5.3 version by default" do
      should include_sexp [:cmd, "hererocks $HOME/.lua -r^ --lua=5.3",
        assert: true, echo: true, timing: true]
    end

    it "installs Lua 5.2 version when specified" do
      data[:config][:lua] = "5.2"
      should include_sexp [:cmd, "hererocks $HOME/.lua -r^ --lua=5.2",
        assert: true, echo: true, timing: true]
    end

    it "installs Lua 5.1 version when specified" do
      data[:config][:lua] = "5.1"
      should include_sexp [:cmd, "hererocks $HOME/.lua -r^ --lua=5.1",
        assert: true, echo: true, timing: true]
    end

    it "installs LuaJIT 2.0 version when specified" do
      data[:config][:lua] = "luajit-2.0"
      should include_sexp [:cmd, "hererocks $HOME/.lua -r^ --luajit=2.0",
        assert: true, echo: true, timing: true]
    end

    it "installs LuaJIT 2.1 version when specified" do
      data[:config][:lua] = "luajit-2.1"
      should include_sexp [:cmd, "hererocks $HOME/.lua -r^ --luajit=2.1",
        assert: true, echo: true, timing: true]
    end

    it 'throws a error with a invalid version' do
      data[:config][:lua] = "foo"
      should include_sexp [:echo, "\"foo\" is an invalid version of Lua.\nView valid versions of Lua at https://docs.travis-ci.com/user/languages/lua/"]
    end
  end
end
