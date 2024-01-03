import 'package:aitapp/const.dart';
import 'package:aitapp/models/contact.dart';
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
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text('各所連絡先'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          if (contacts[index] is Contact) {
            final contact = contacts[index] as Contact;
            return ListTile(
              title: Text(contact.name),
              subtitle: Text(contact.explain),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '電話',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                contact.phone,
                                style: Theme.of(context).textTheme.titleMedium,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'メール',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Text(
                                  contact.mail!,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
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
            );
          } else {
            return ListTile(
              title: Text(
                contacts[index] as String,
              ),
              tileColor: Theme.of(context).colorScheme.secondaryContainer,
            );
          }
        },
      ),
    );
  }
}
