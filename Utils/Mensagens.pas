unit Mensagens;

interface

const
  SSeisZerosFmt = '%.6d';
  SMsgCodigoNomeFmt = Concat(SSeisZerosFmt, ' - %s');
  SMsgClienteNaoEncontrado = Concat('Cliente não encontrado');
  SMsgProdutoNaoEncontrado = Concat('Produto não encontrado');
  SMsgApagarProdutoFmt = 'Deseja apagar produto %s?';
  SMsgPedidoGravado = Concat('Pedido #', SSeisZerosFmt, ' gravado com sucesso');
  SMsgPedidoNaoEncontrado = Concat('Pedido #', SSeisZerosFmt, ' não encontrado');
  SMsgPedidoClienteFmt = Concat('[#', SSeisZerosFmt, '] %s');
  SMsgApagarPedidoFmt = Concat('Deseja apagar pedido #', SSeisZerosFmt, '?');
  SMsgPedidoApagado = Concat('Pedido #', SSeisZerosFmt, ' apagado com sucesso!');
  SMsgPedidoNaoApagado = Concat('Não foi possível apagar pedido #', SSeisZerosFmt);

implementation

end.
