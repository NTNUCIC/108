#�i���ʳ�����O
class Actor < Unit
  def initialize(path,x,range,hp)
    super(path,x,hp)
    @h=@img.height
    @y=0
    #�[�W�@���H���������q���Ϥ����n�������|
    @offset=rand(20)
    @range=range
  end
  def update
    @draw_x=@x-@w/2
    @draw_y=250-@h-@offset
  end
  def draw
    #ø���B�~�H����ӱƧ�
    @img.draw(@draw_x,@draw_y,ZOrder::Actor-@offset*0.05)
  end
end
