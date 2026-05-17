part of product_management_app;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController(text: 'admin@example.com');
  final passwordController = TextEditingController(text: 'Admin@123456');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final expanded = constraints.maxWidth >= Responsive.desktopMin;
            return Center(
              child: SingleChildScrollView(
                padding: Responsive.pagePadding(context),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: expanded ? 920 : 440),
                  child: FadeSlideIn(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(expanded ? 28 : 22),
                        child: expanded
                            ? Row(
                                children: [
                                  const Expanded(child: LoginBrandPanel()),
                                  const SizedBox(width: 28),
                                  SizedBox(width: 380, child: LoginForm(emailController: emailController, passwordController: passwordController)),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const LoginBrandPanel(compact: true),
                                  const SizedBox(height: 20),
                                  LoginForm(emailController: emailController, passwordController: passwordController),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LoginBrandPanel extends StatelessWidget {
  const LoginBrandPanel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: EdgeInsets.all(compact ? 0 : 24),
      decoration: compact
          ? null
          : BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFE0F3EC),
            ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: compact ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: compact ? 28 : 34,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.local_convenience_store),
          ),
          const SizedBox(height: 18),
          Text(
            '7-Eleven Product Management',
            textAlign: compact ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          if (!compact) ...[
            const SizedBox(height: 10),
            Text(
              'Manage products, Cloudinary images, carts and order fulfillment from one responsive dashboard.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.error != null) showSnack(context, state.error!);
      },
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.mail_outline)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () => context.read<AuthCubit>().login(
                        emailController.text.trim(),
                        passwordController.text,
                      ),
              icon: state.isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.login),
              label: const Text('Sign in'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                emailController.text = 'user@example.com';
                passwordController.text = 'User@123456';
              },
              child: const Text('Use demo user'),
            ),
          ],
        );
      },
    );
  }
}
