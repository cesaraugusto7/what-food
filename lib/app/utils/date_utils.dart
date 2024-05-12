class DateUtils {
  static Map<String, String> diaSemana = {
    '1': 'segunda-feira',
    '2': 'terça-feira',
    '3': 'quarta-feira',
    '4': 'quinta-feira',
    '5': 'sexta-feira',
    '6': 'sabádo',
    '7': 'domingo',
  };

  static Map<String, String> mesAno = {
    '01': 'Janeiro',
    '02': 'Fevereiro',
    '03': 'Março',
    '04': 'Abril',
    '05': 'Maio',
    '06': 'Junho',
    '07': 'Julho',
    '08': 'Agosto',
    '09': 'Setembro',
    '10': 'Outubro',
    '11': 'Novembro',
    '12': 'Dezembro',
  };

  Map<String, dynamic> returnDateNow(DateTime? dateTime) {
    dateTime = dateTime ?? DateTime.now();
    String dia = dateTime.day.toString().padLeft(2, '0');
    String mes = dateTime.month.toString().padLeft(2, '0');
    String ano = dateTime.year.toString();
    String hora = dateTime.hour.toString().padLeft(2, '0');
    String minuto = dateTime.minute.toString().padLeft(2, '0');
    String segundo = dateTime.second.toString().padLeft(2, '0');
    return {
      'date_extenso':
          '$dia de ${mesAno[mes]} de $ano às $hora:$minuto:$segundo,horário de Brasília',
      'date_hours': '$hora:$minuto',
      'date_string_br': '$dia$mes$ano',
      'date_string_us': '$ano$mes$dia',
      'date_timestamp': dateTime.toString(),
      'date_value_br': '$dia/$mes/$ano',
      'date_value_us': '$ano-$mes-$dia',
      'day': dia,
      'day_week': dateTime.weekday,
      'day_week_string': diaSemana[dateTime.weekday],
      'monnth': mes,
      'year': ano,
    };
  }
}
