class NumberFilter{
  final int maxValue;
  final int minValue;

  NumberFilter({this.maxValue,this.minValue});
  String toString(){
    return "NumberFilter :{maxValue : $maxValue, minValue : $minValue }";
  }
}