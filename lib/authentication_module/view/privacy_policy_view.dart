import 'package:flutter/material.dart';
import 'package:school_management/utils/navigation/navigator.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

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
          "Privacy Policy",
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

            // Privacy Content
            _buildSection(
              title: "1. Introduction",
              content: "CineMarathi ('we', 'our', or 'us') is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.",
            ),
            
            _buildSection(
              title: "2. Information We Collect",
              content: "We collect information that you provide directly to us, including:\n\n• Personal Information: Name, email address, phone number, profile picture\n• Account Information: Username, password, profile details\n• Content: Portfolio images, bio, skills, professional information\n• Usage Data: How you interact with our app, features used, time spent\n• Device Information: Device type, operating system, unique device identifiers",
            ),
            
            _buildSection(
              title: "3. How We Use Your Information",
              content: "We use the information we collect to:\n\n• Provide, maintain, and improve our services\n• Process transactions and send related information\n• Send you technical notices and support messages\n• Respond to your comments and questions\n• Personalize your experience\n• Monitor and analyze trends and usage\n• Detect, prevent, and address technical issues",
            ),
            
            _buildSection(
              title: "4. Information Sharing",
              content: "We do not sell your personal information. We may share your information only in the following circumstances:\n\n• With your consent\n• To comply with legal obligations\n• To protect our rights and safety\n• With service providers who assist us in operating our app\n• In connection with a business transfer or merger",
            ),
            
            _buildSection(
              title: "5. Data Security",
              content: "We implement appropriate technical and organizational security measures to protect your personal information. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.",
            ),
            
            _buildSection(
              title: "6. Data Retention",
              content: "We retain your personal information for as long as necessary to provide you with our services and fulfill the purposes described in this policy. We may retain certain information as required by law or for legitimate business purposes.",
            ),
            
            _buildSection(
              title: "7. Your Rights",
              content: "You have the right to:\n\n• Access your personal information\n• Correct inaccurate data\n• Request deletion of your data\n• Object to processing of your data\n• Request data portability\n• Withdraw consent at any time",
            ),
            
            _buildSection(
              title: "8. Cookies and Tracking",
              content: "We use cookies and similar tracking technologies to track activity on our app and hold certain information. You can instruct your browser to refuse all cookies or to indicate when a cookie is being sent.",
            ),
            
            _buildSection(
              title: "9. Third-Party Services",
              content: "Our app may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to read their privacy policies.",
            ),
            
            _buildSection(
              title: "10. Children's Privacy",
              content: "Our services are not intended for children under the age of 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.",
            ),
            
            _buildSection(
              title: "11. Changes to This Policy",
              content: "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the 'Last updated' date.",
            ),
            
            _buildSection(
              title: "12. Contact Us",
              content: "If you have any questions about this Privacy Policy, please contact us at:\n\nEmail: privacy@cinemarathi.com\nSupport: support@cinemarathi.com\nAddress: CineMarathi Privacy Team",
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


