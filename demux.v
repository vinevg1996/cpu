// **************
// *модуль demux*
// **************
// Демультиплексор.
// 
// Входные данные непрерывно перенаправляются в кусок (подшину) шины выходных данных, задаваемый номером, подаваемым на вход.
// 
// = Входы =
// [шина] in [W       ]: входные данные.
// [шина] n  [bits4(N)]: номер куска.
//
// = Выходы =
// [шина] out [W*N]: выходные данные.
//
// = Параметры =
// [integer] W [1]: ширина входных данных и каждого куска выходных данных.
// [integer] N [2]: общее число кусков в выходных данных; должно быть хотя бы 2 куска.
// 
// = Ограничения на параметры =
// W >= 1
// N >= 1
// 
// = Функционирование =
// Выходные данные разбиты на N кусков chunk(k) ширины W:
//   out == {chunk(0), chunk(1), ..., chunk(N-1)}
//   (в порядке, обратном порядку нумерации битов шин - для удобочитаемости при задании портов экземпляра).
// 
// * @ always:
//   если 0 <= n < N, то
//     chunk(n) <- in
//   для каждого k, 0 <= k < N, k != n:
//     chunk(k) <- 0
// 
// = Пример использования =
// wire [4:0] in;
// wire [1:0] sel;
// wire [4:0] out0, out1, out2;
// demux #(.W(5), .N(3)) _demux(in, sel, {out0, out1, out2});
// * sel == 0 => out0 == in, out1 == out2 == 0
// * sel == 1 => out1 == in, out0 == out2 == 0
// * sel == 2 => out2 == in, out0 == out1 == 0
// * sel == 3 => out0 == out1 == out2 == 0
// 
// = Модуль написал =
// Владислав Подымов
// 2018
// e-mail: valdus@yandex.ru
module demux(in, n, out);
  parameter integer W = 1;
  parameter integer N = 2;
  localparam CW = (N == 1)
                  ? 1
                  : $clog2(N);
  input [W-1:0] in;
  input [CW-1:0] n;
  output [W*N-1:0] out;
  
  reg [W-1:0] chunk[0:N-1];
  
  always @(*)
  begin : demux_block
    integer k;
    for(k = 0; k < N; k = k + 1)
      chunk[k] = {{W{1'b0}}};
    if(n < N)
      chunk[n] = in;
  end
  
  generate
    genvar k;
    for(k = 0; k < N; k = k + 1)
    begin : assign_block
      assign out[W*(N-k)-1:W*(N-1-k)] = chunk[k];
    end
  endgenerate
endmodule
