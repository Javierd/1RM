class Calculator{

  static double estimateRM(double weight, int reps) => weight*36/(37-reps);

  static double estimateWeight(double rm, int reps) => rm*(37-reps)/36;
}