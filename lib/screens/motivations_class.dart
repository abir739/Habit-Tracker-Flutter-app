import 'dart:ui';

class MotivationalQuote {
  final String text;
  final TextDirection direction;

  MotivationalQuote(this.text, {this.direction = TextDirection.ltr});
}

final List<MotivationalQuote> motivationalQuotes = [
  MotivationalQuote(
    "Tu n’as pas besoin d’être motivé tous les jours. Tu as juste besoin d’être discipliné un peu chaque jour.",
  ),
  MotivationalQuote(
    "📌 النجاح لا يبدأ بالاندفاع، بل بالاستمرارية.",
    direction: TextDirection.rtl,
  ),
  MotivationalQuote(
    "هذه لحظة تطويري. مهما كان شعوري، سأحترم هذا الموعد. أنا أعمل من أجل نفسي، من أجل مستقبلي، من أجل خروجي من الدائرة الحالية. البدايات من جديد لا تُقلل من قيمتك، بل تُثبت أنك أقوى من كل عثرة.",
    direction: TextDirection.rtl,
  ),
  MotivationalQuote("Small steps every day lead to big results."),
  MotivationalQuote(
    "💬أنت لست ضعيفًا، أنت فقط توقفت لفترة. ولكن الآن، أنت في لحظة الرجوع، ولحظة الرجوع هي بداية النصر.",
    direction: TextDirection.rtl,
  ),
  MotivationalQuote("Consistency is the key to success."),
  MotivationalQuote("Your habits shape your future."),
  MotivationalQuote(
    "💬الألم الذي تشعر به لأنك لم تدرس، هو نفسه الوقود الذي سيحملك نحو النجاح، فقط تحرّك.",
    direction: TextDirection.rtl,
  ),
  MotivationalQuote("Every day is a new chance to grow."),
  MotivationalQuote(
    "💬 افعل القليل اليوم... وغدًا ستكون شخصًا يتجاوز المقابلات بثقة.",
    direction: TextDirection.rtl,
  ),
  MotivationalQuote("Stay committed, and watch your progress soar!"),
];