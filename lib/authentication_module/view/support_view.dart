import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:school_management/utils/navigation/navigator.dart';

class SupportView extends StatelessWidget {
  const SupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0B1A),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            MyNavigator.pop();
          },
          child: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
        ),
        title: Text(
          "Support",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
        backgroundColor: const Color(0xFF0D0B1A),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // Header Section
            _buildHeaderSection(context),
            
            const SizedBox(height: 40),
            
            // Contact Section
            _buildSectionTitle("Contact Us"),
            const SizedBox(height: 16),
            _buildContactCard(
              icon: Icons.email,
              title: "Email",
              subtitle: "support@cinemarathi.com",
              onTap: () => _launchEmail("support@cinemarathi.com"),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.phone,
              title: "Phone",
              subtitle: "+91 1234567890",
              onTap: () => _launchPhone("+911234567890"),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              icon: Icons.chat_bubble_outline,
              title: "Live Chat",
              subtitle: "Available 24/7",
              onTap: () {
                // TODO: Implement live chat
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Live chat feature coming soon!"),
                    backgroundColor: Colors.pinkAccent,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            // FAQ Section
            _buildSectionTitle("Frequently Asked Questions"),
            const SizedBox(height: 16),
            _buildFAQItem(
              question: "How do I create a profile?",
              answer: "Go to your profile page and tap 'Edit Profile' to add your information, skills, and portfolio.",
            ),
            _buildFAQItem(
              question: "How do I apply for jobs?",
              answer: "Browse available jobs in the Jobs section and tap on any job to view details and apply.",
            ),
            _buildFAQItem(
              question: "How do I contact other users?",
              answer: "You can send messages through the Chat section or view public profiles to connect with talents.",
            ),
            _buildFAQItem(
              question: "What payment methods are accepted?",
              answer: "We accept various payment methods including credit/debit cards, UPI, and digital wallets through Razorpay.",
            ),
            
            const SizedBox(height: 40),
            
            // Help Resources
            _buildSectionTitle("Help Resources"),
            const SizedBox(height: 16),
            _buildHelpCard(
              icon: Icons.help_outline,
              title: "User Guide",
              subtitle: "Learn how to use CineMarathi",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("User guide coming soon!"),
                    backgroundColor: Colors.pinkAccent,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildHelpCard(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              subtitle: "Read our privacy policy",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Privacy policy page coming soon!"),
                    backgroundColor: Colors.pinkAccent,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildHelpCard(
              icon: Icons.description_outlined,
              title: "Terms of Service",
              subtitle: "Read our terms and conditions",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Terms of service page coming soon!"),
                    backgroundColor: Colors.pinkAccent,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.pinkAccent, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.support_agent,
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 16),
          Text(
            "We're Here to Help!",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            "Get in touch with our support team for any questions or assistance",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.pinkAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.pinkAccent, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.help_outline,
                color: Colors.pinkAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: Text(
              answer,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.purpleAccent, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Support Request from CineMarathi App',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }
}


