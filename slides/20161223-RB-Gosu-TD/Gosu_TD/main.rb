#!/usr/bin/ruby
#coding: utf-8

#�ޤJGosu�禡�w
require 'gosu'
#�ޤJ�ӵ{���һ����O
require_relative 'unit'
require_relative 'actor'
require_relative 'tower'
require_relative 'cat'
require_relative 'rat'
#�ϼh�Ϥ�
module ZOrder
  Background, Tower, Actor , UI = *0..4
end
#�r��ø�ϥγ�@�������O
class Text
  #��l��
  def self.init
    @font=Gosu::Font.new(24)
  end
  #ø�����
  def self.draw(*arg)
    @font.draw(*arg)
  end
end
#�C���������O
class Game < Gosu::Window
  #�غc�l
  def initialize
    super(640,320)
    #�]�w���D
    self.caption="Cats And Rats"
    #��l�Ʀr��ø�ϥ\��
    Text.init
    #�ĤH����C(�]�t�Ĥ�D��)
    @enemy_queue=[Tower.new("TowerR.bmp",50,20000)]
    #�ڤ����C(�]�t�ڤ�D��)
    @ally_queue=[Tower.new("TowerB.bmp",590,20000)]
    #�I���a�O��m
    @ground=Gosu::Color.argb(0xff00ff00)
    #�I���ѪŦ�m
    @sky=Gosu::Color.argb(0xff00ffff)
    #�Ӷ��Ϯ�
    @sun=Gosu::Image.new("Sun.bmp")
    #�U���i�A�Ͳ��߫}
    @cat_cd={
      Kitten => 0,
      SpearCat => 0,
      UFOCat => 0
    }
    #�U�ؿ߫}�Ͳ��N�o�ɶ�
    @cat_cold={
      Kitten => 480,
      SpearCat => 2400,
      UFOCat => 4200
    }
    #�߫}����������
    @hotkey={
      Gosu::KbC => Kitten,
      Gosu::KbV => SpearCat,
      Gosu::KbB => UFOCat
    }
    #�ѹ��i�H���W�Ͳ�
    @rat_cd=0
    #�ѹ��N�o�ɶ�
    @rat_cold=3600
  end
  #�C�ӵe�檺��s
  def update
    #�ӭt�M�w����w�ާ@
    unless @winner
      #�ѹ��H�@�w���j�۰ʲ���
      if @rat_cd<Gosu.milliseconds
        @enemy_queue<<Rat.new
        @rat_cd=Gosu.milliseconds+@rat_cold
      end
      #���y�U�ؿ߫}��������æb�i�Ͳ��ɲ��Ϳ߫}
      @hotkey.each{|key,cat|
        if button_down?(key)&&@cat_cd[cat]<Gosu.milliseconds
          @ally_queue<<cat.new
          @cat_cd[cat]=Gosu.milliseconds+@cat_cold[cat]
        end
      }
    end
    #��s�ڤ�μĤ説�A
    @ally_queue.each{|ally| ally.update(@enemy_queue) }
    @enemy_queue.each{|enemy| enemy.update(@ally_queue) }
    #�h�����`���
    @ally_queue.keep_if(&:alive?)
    @enemy_queue.keep_if(&:alive?)
    #�ӭt�P�w�H�θ��J��Ӵ��ܹϤ�
    @winner or @winner=check_winner and @hint=Gosu::Image.new("#{@winner}Wins.bmp")
  end
  #�ӭt�P�w
  def check_winner
    @ally_queue.empty? and return :Rat
    @enemy_queue.empty? and return :Cat
    @ally_queue.first.alive? or return :Rat
    @enemy_queue.first.alive? or return :Cat
    return nil
  end
  #ø�Ϩ禡
  def draw
    draw_quad(0,200,@ground,640,200,@ground,640,320,@ground,0,320,@ground,ZOrder::Background)
    draw_quad(0,0,@sky,640,0,@sky,640,200,@sky,0,200,@sky,ZOrder::Background)
    @sun.draw(500,20,ZOrder::Background)
    @enemy_queue.each &:draw
    @ally_queue.each &:draw
    #����Ӵ��ܤ~�e
    @hint&.draw(120,60,ZOrder::UI)
  end
end
game = Game.new
game.show