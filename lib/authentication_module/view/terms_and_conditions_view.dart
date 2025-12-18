import 'package:flutter/material.dart';
import 'package:school_management/utils/navigation/navigator.dart';

class TermsAndConditionsView extends StatelessWidget {
  const TermsAndConditionsView({super.key});

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
          "Terms & Conditions",
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

            // Terms Content
            _buildSection(
              title: "1. Acceptance of Terms",
              content: "By accessing and using CineMarathi, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.",
            ),
            
            _buildSection(
              title: "2. Use License",
              content: "Permission is granted to temporarily use CineMarathi for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:\n\n• Modify or copy the materials\n• Use the materials for any commercial purpose\n• Attempt to decompile or reverse engineer any software\n• Remove any copyright or other proprietary notations",
            ),
            
            _buildSection(
              title: "3. User Accounts",
              content: "You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account or password.",
            ),
            
            _buildSection(
              title: "4. Content and Conduct",
              content: "Users are responsible for all content they post, upload, or share on CineMarathi. You agree not to:\n\n• Post any content that is illegal, harmful, or violates any laws\n• Infringe on intellectual property rights\n• Harass, abuse, or harm other users\n• Post false or misleading information\n• Spam or send unsolicited messages",
            ),
            
            _buildSection(
              title: "5. Intellectual Property",
              content: "All content on CineMarathi, including but not limited to text, graphics, logos, images, and software, is the property of CineMarathi or its content suppliers and is protected by copyright and other intellectual property laws.",
            ),
            
            _buildSection(
              title: "6. Payment Terms",
              content: "If you purchase a subscription or service, you agree to pay all fees associated with your account. All fees are non-refundable unless otherwise stated. We reserve the right to change our pricing at any time.",
            ),
            
            _buildSection(
              title: "7. Termination",
              content: "We reserve the right to terminate or suspend your account and access to the service immediately, without prior notice, for conduct that we believe violates these Terms of Service or is harmful to other users, us, or third parties.",
            ),
            
            _buildSection(
              title: "8. Disclaimer",
              content: "The materials on CineMarathi are provided on an 'as is' basis. CineMarathi makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties including, without limitation, implied warranties or conditions of merchantability, fitness for a particular purpose, or non-infringement of intellectual property or other violation of rights.",
            ),
            
            _buildSection(
              title: "9. Limitations",
              content: "In no event shall CineMarathi or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit, or due to business interruption) arising out of the use or inability to use the materials on CineMarathi.",
            ),
            
            _buildSection(
              title: "10. Revisions",
              content: "CineMarathi may revise these terms of service at any time without notice. By using this service you are agreeing to be bound by the then current version of these terms of service.",
            ),
            
            _buildSection(
              title: "11. Contact Information",
              content: "If you have any questions about these Terms & Conditions, please contact us at:\n\nEmail: legal@cinemarathi.com\nSupport: support@cinemarathi.com",
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
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
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}


