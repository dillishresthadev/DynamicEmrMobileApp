import 'package:dynamic_emr/features/payrolls/domain/entities/taxes_entity.dart';
import 'package:dynamic_emr/features/payrolls/presentation/bloc/payroll_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaxesCard extends StatelessWidget {
  const TaxesCard({super.key});

  static const _headerStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
  );

  static const _cellStyle = TextStyle(fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PayrollBloc, PayrollState>(
      builder: (context, state) {
        switch (state.taxesStatus) {
          case PayrollStatus.loading:
            return const Center(child: CircularProgressIndicator());

          case PayrollStatus.success:
            if (state.taxes.isEmpty) {
              return const Center(child: Text('No tax details available'));
            }

            final taxData = state.taxes;
            return Card(
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tax Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _TableHeader(),

                    _TableBody(taxData: taxData),
                  ],
                ),
              ),
            );

          default:
            return const SizedBox();
        }
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3498DB).withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text('Month', style: TaxesCard._headerStyle),
          ),
          Expanded(flex: 2, child: Text('SST', style: TaxesCard._headerStyle)),
          Expanded(
            flex: 2,
            child: Text('Income Tax', style: TaxesCard._headerStyle),
          ),
          Expanded(
            flex: 2,
            child: Text('Total', style: TaxesCard._headerStyle),
          ),
        ],
      ),
    );
  }
}

class _TableBody extends StatelessWidget {
  final List<TaxesEntity> taxData; // replace dynamic with your model type

  const _TableBody({required this.taxData});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
      ),
      child: Column(
        children: taxData.asMap().entries.map((entry) {
          int index = entry.key;
          final data = entry.value;
          bool isLast = index == taxData.length - 1;

          return _TableRowItem(
            month: "${data.year}/ ${data.month}",
            sst: data.sst,
            incomeTax: data.incomeTax,
            total: data.totalDeduction,
            isLast: isLast,
          );
        }).toList(),
      ),
    );
  }
}

class _TableRowItem extends StatelessWidget {
  final String month;
  final double sst;
  final double incomeTax;
  final double total;
  final bool isLast;

  const _TableRowItem({
    required this.month,
    required this.sst,
    required this.incomeTax,
    required this.total,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(month, style: TaxesCard._cellStyle)),
          Expanded(
            flex: 2,
            child: Text(
              'Rs. ${sst.toStringAsFixed(0)}',
              style: TaxesCard._cellStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rs. ${incomeTax.toStringAsFixed(0)}',
              style: TaxesCard._cellStyle,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Rs. ${total.toStringAsFixed(0)}',
              style: TaxesCard._cellStyle.copyWith(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF3498DB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
