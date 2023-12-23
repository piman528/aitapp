import 'package:aitapp/const.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contacts extends StatelessWidget {
  const Contacts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('各所連絡先'),
      ),
      body: ListView(
        children: [
          ...contacts.entries.map(
            (e) {
              return Column(
                children: [
                  for (final contact in e.value) ...{
                    ListTile(
                      title: Text(contact.name),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(contact.phone),
                          if (contact.mail != null) ...{
                            Text(contact.mail!),
                          },
                        ],
                      ),
                      onTap: () {
                        showDialog<Widget>(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              title: const Text(
                                '連絡方法の選択',
                              ),
                              children: [
                                SimpleDialogOption(
                                  onPressed: () {
                                    launchUrl(
                                      Uri(
                                        scheme: 'tel',
                                        path: contact.phone,
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '電話',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      Text(
                                        contact.phone,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  ),
                                ),
                                if (contact.mail != null) ...{
                                  SimpleDialogOption(
                                    onPressed: () {
                                      launchUrl(
                                        Uri(
                                          scheme: 'mailto',
                                          path: contact.mail,
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'メール',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        const SizedBox(
                                          width: 50,
                                        ),
                                        Text(
                                          contact.mail!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                },
                              ],
                            );
                          },
                        );
                      },
                    ),
                  },
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
