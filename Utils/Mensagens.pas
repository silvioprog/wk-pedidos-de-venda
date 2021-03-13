unit Mensagens;

interface

const
  SSeisZerosFmt = '%.6d';
  SMsgCodigoNomeFmt = Concat(SSeisZerosFmt, ' - %s');
  SMsgClienteNaoEncontrado = Concat('Cliente n�o encontrado');
  SMsgProdutoNaoEncontrado = Concat('Produto n�o encontrado');
  SMsgApagarProdutoFmt = 'Deseja apagar produto %s?';
  SMsgPedidoGravado = Concat('Pedido #', SSeisZerosFmt, ' gravado com sucesso');
  SMsgPedidoNaoEncontrado = Concat('Pedido #', SSeisZerosFmt, ' n�o encontrado');
  SMsgPedidoClienteFmt = Concat('[#', SSeisZerosFmt, '] %s');
  SMsgApagarPedidoFmt = Concat('Deseja apagar pedido #', SSeisZerosFmt, '?');
  SMsgPedidoApagado = Concat('Pedido #', SSeisZerosFmt, ' apagado com sucesso!');
  SMsgPedidoNaoApagado = Concat('N�o foi poss�vel apagar pedido #', SSeisZerosFmt);

implementation

end.
