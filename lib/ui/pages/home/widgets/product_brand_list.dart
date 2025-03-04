import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/model/product/brand.dart';

class ProductBrandList extends StatelessWidget {
  const ProductBrandList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: brands.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          Brand brand = brands[index];
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.grey, width: 0.3),
                    ),
                    color: Colors.white,
                  ),
                  child: (brand.brandLogo == null || brand.brandLogo!.isEmpty)
                      ? Center(
                          child: Text(
                          brand.brandName!,
                          style: GoogleFonts.acme(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.1,
                              fontSize: 16),
                        ))
                      : Image.asset(
                          brand.brandLogo ??
                              brand.brandLogo ??
                              'assets/images/brand/default.png',
                          fit: BoxFit.contain,
                        ),
                ),
                const SizedBox(height: 8),
                Text(
                  brand.brandName!,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
